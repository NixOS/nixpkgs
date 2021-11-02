{ buildPythonPackage, fetchPypi, atpublic }:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "3.2";

  propagatedBuildInputs = [ atpublic ];

  doCheck = false;

  pythonImportsCheck = [ "flufl.i18n" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-w1yPjqtmrbf9ZKFCCGAQUGbSs2y2VbM/+xSv6OIj7WI=";
  };
}
