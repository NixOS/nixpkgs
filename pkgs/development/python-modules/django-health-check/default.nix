{ lib
, fetchFromGitHub
, buildPythonPackage
, sphinx
, setuptools-scm
, django
, redis
, celery
, pytest-django
, pytestCheckHook
, mock
, gitMinimal }:

buildPythonPackage rec {
  pname = "django-health-check";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "KristianOellegaard";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9AspaARz6ww5Y2nTDji4RaJ4+OWF13c3DSEebrGS8eM=";
    leaveDotGit = true;
  };

  buildInputs = [
    sphinx
    django
  ];

  nativeBuildInputs = [
    setuptools-scm
    gitMinimal
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook
    mock
    celery
    redis
  ];

  postPatch = ''
    # We don't want to generate coverage
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "--cov=health_check" "" \
      --replace "--cov-report=term" "" \
      --replace "--cov-report=xml" ""
  '';

  pythonImportsCheck = [ "health_check" ];

  meta = with lib; {
    description = "Pluggable app that runs a full check on the deployment";
    homepage = "https://github.com/KristianOellegaard/django-health-check";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
