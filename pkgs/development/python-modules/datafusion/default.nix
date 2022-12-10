{ lib
, stdenv
, fetchurl
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, rustPlatform
, maturin
, pytestCheckHook
, libiconv
, numpy
, pandas
, pyarrow
, pytest
}:
let
  # le sigh, the perils of unrelated versions of software living in the same
  # repo: there's no obvious way to map the top level source repo
  # (arrow-datafusion) version to the version of contained repo
  # (arrow-datafusion/python)
  #
  # A commit hash will do in a pinch, and ultimately the sha256 has the final
  # say of what the content is when building
  cargoLock = fetchurl {
    url = "https://raw.githubusercontent.com/apache/arrow-datafusion/6.0.0/python/Cargo.lock";
    sha256 = "sha256-xiv3drEU5jOGsEIh0U01ZQ1NBKobxO2ctp4mxy9iigw=";
  };

  postUnpack = ''
    cp "${cargoLock}" $sourceRoot/Cargo.lock
    chmod u+w $sourceRoot/Cargo.lock
  '';
in
buildPythonPackage rec {
  pname = "datafusion";
  version = "0.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+YqogteKfNhtI2QbVXv/5CIWm3PcOH653dwONm5ZcL8=";
  };

  inherit postUnpack;

  # TODO: remove the patch hacking and postUnpack hooks after
  # https://github.com/apache/arrow-datafusion/pull/1508 is merged
  #
  # the lock file isn't up to date as of 6.0.0 so we need to patch the source
  # lockfile and the vendored cargo deps lockfile
  patches = [ ./Cargo.lock.patch ];
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src pname version postUnpack;
    sha256 = "sha256-JGyDxpfBXzduJaMF1sbmRm7KJajHYdVSj+WbiSETiY0=";
    patches = [ ./Cargo.lock.patch ];
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

  checkInputs = [ pytest ];
  pythonImportsCheck = [ "datafusion" ];

  checkPhase = ''
    runHook preCheck
    pytest --pyargs "${pname}"
    runHook postCheck
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
