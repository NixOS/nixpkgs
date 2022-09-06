{ buildPythonPackage, fetchPypi
, atpublic
, pdm-pep517
}:

buildPythonPackage rec {
  pname = "flufl.i18n";
  version = "4.1.1";
  format = "pyproject";

  nativeBuildInputs = [ pdm-pep517 ];
  propagatedBuildInputs = [ atpublic ];

  doCheck = false;

  pythonImportsCheck = [ "flufl.i18n" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wKz6aggkJ9YBJ+o75XjC4Ddnn+Zi9hlYDnliwTc7DNs=";
  };
}
