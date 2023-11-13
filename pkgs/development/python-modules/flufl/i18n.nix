{ lib
, buildPythonPackage
, fetchPypi
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
    hash = "sha256-wKz6aggkJ9YBJ+o75XjC4Ddnn+Zi9hlYDnliwTc7DNs=";
  };

  meta = with lib; {
    description = "A high level API for internationalizing Python libraries and applications";
    homepage = "https://gitlab.com/warsaw/flufl.i18n";
    changelog = "https://gitlab.com/warsaw/flufl.i18n/-/raw/${version}/docs/NEWS.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
