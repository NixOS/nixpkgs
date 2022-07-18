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

buildPythonPackage rec {
  pname = "datafusion";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xiLA+hlloWyglTejH9HH7SsvxtFSJe7/ZjMaRNuXVXk=";
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
