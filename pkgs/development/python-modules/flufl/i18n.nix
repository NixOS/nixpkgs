{ buildPythonPackage, fetchPypi
, atpublic
, pdm-pep517
}:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "4.0";
  format = "pyproject";

  nativeBuildInputs = [ pdm-pep517 ];
  propagatedBuildInputs = [ atpublic ];

  doCheck = false;

  pythonImportsCheck = [ "flufl.i18n" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MTq0djhFp/cEx0Ezt5EaMz3MzrAWjxZ0HQSkfFuasWY=";
  };
}
