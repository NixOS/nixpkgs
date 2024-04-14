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
  version = "3.18.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "KristianOellegaard";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-4fl7x0pleI1yL+tEWGt5Gmcl6ZKETQz2AsNQDVIAwy8=";
  };

  buildInputs = [
    sphinx
    django
  ];

  nativeBuildInputs = [
    setuptools-scm
    gitMinimal
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    mock
    celery
    redis
  ];

  disabledTests = [
    # commandline output mismatch
    "test_command_with_non_existence_subset"
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
