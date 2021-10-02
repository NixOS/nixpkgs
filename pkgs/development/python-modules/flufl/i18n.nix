{ buildPythonPackage, fetchPypi, atpublic }:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "3.1.5";

  propagatedBuildInputs = [ atpublic ];

  doCheck = false;

  pythonImportsCheck = [ "flufl.i18n" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7016000a4d9d366866e776947b777dbe2b1532c990efeef58922b3e7bcab36e";
  };
}
