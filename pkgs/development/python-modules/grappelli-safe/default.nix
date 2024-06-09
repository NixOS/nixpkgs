{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  version = "1.1.1";
  pname = "grappelli-safe";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "grappelli_safe";
    inherit version;
    hash = "sha256-7jSz4qNxFJix+No9naqKEjnv3yVaISGBdCtqWJD6wDk=";
  };

  nativeBuildInputs = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "grappelli_safe" ];

  meta = with lib; {
    description = "A snapshot of django-grappelli for the Mezzanine CMS";
    longDescription = ''
      grappelli_safe was created to provide a snapshot of the
      Grappelli admin skin for Django, to be referenced as a
      dependency for the Mezzanine CMS for Django.

      At the time of grappelli_safe's creation, Grappelli was
      incorrectly packaged on PyPI, and had also dropped compatibility
      with Django 1.1 - grappelli_safe was therefore created to
      address these specific issues.
    '';
    homepage = "https://github.com/stephenmcd/grappelli-safe";
    downloadPage = "http://pypi.python.org/pypi/grappelli_safe/";
    changelog = "https://github.com/stephenmcd/grappelli-safe/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
  };
}
