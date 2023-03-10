{ lib
, stdenv
, fetchurl
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, rustPlatform
, pytestCheckHook
, libiconv
, numpy
, pandas
, pyarrow
}:

let
  arrow-testing = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-testing";
    rev = "5bab2f264a23f5af68f69ea93d24ef1e8e77fc88";
    hash = "sha256-Pxx8ohUpXb5u1995IvXmxQMqWiDJ+7LAll/AjQP7ph8=";
  };

  parquet-testing = fetchFromGitHub {
    owner = "apache";
    repo = "parquet-testing";
    rev = "5b82793ef7196f7b3583e85669ced211cd8b5ff2";
    hash = "sha256-gcOvk7qFHZgJWE9CpucC8zwayYw47VbC3lmSRu4JQFg=";
  };
in

buildPythonPackage rec {
  pname = "datafusion";
  version = "0.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XYXZMorPs2Ue7E38DASd4rmxvX0wlx8A6sCpAbYUh4I=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src pname version;
    sha256 = "sha256-6mPdKwsEN09Gf4eNsd/v3EBHVezHmff/KYB2lsXgzcA=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  propagatedBuildInputs = [
    numpy
    pandas
    pyarrow
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "datafusion" ];
  pytestFlagsArray = [ "--pyargs" pname ];

  preCheck = ''
    pushd $TMPDIR
    ln -s ${arrow-testing} ./testing
    ln -s ${parquet-testing} ./parquet
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    description = "Extensible query execution framework";
    longDescription = ''
      DataFusion is an extensible query execution framework, written in Rust,
      that uses Apache Arrow as its in-memory format.
    '';
    homepage = "https://arrow.apache.org/datafusion/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ cpcloud ];
  };
}
