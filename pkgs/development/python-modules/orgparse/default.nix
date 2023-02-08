{ buildPythonPackage, fetchPypi, lib, setuptools-scm, pytest }:

buildPythonPackage rec {
  pname = "orgparse";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-RRBQ55rLelHGXcmbkJXq5NUL1ZhUE1T552PLTL31mlU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytest ];

  doCheck = true;

  meta = with lib; {
    description = "";
    homepage = "https://orgparse.readthedocs.org/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ qbit ];
  };
}
