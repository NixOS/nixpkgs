{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-debug-toolbar
, psycopg2
, beautifulsoup4
, python
}:

buildPythonPackage rec {
  pname = "django-cachalot";
  version = "2.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "noripyt";
    repo = "django-cachalot";
    rev = "v${version}";
    hash = "sha256-ayAN+PgK3aIpt4R8aeC6c6mRGTnfObycmkoXPTjx4WI=";
  };

  patches = [
    # Disable tests for unsupported caching and database types which would
    # require additional running backends
    ./disable-unsupported-tests.patch
  ];

  propagatedBuildInputs = [
    django
  ];

  checkInputs = [
    beautifulsoup4
    django-debug-toolbar
    psycopg2
  ];

  pythonImportsCheck = [ "cachalot" ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "No effort, no worry, maximum performance";
    homepage = "https://github.com/noripyt/django-cachalot";
    changelog = "https://github.com/noripyt/django-cachalot/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
