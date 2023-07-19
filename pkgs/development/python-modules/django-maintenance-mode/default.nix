{ lib
, fetchFromGitHub
, fetchpatch
, buildPythonPackage
, django
, python-fsutil
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-maintenance-mode";
  version = "0.18.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fabiocaccamo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Mcj8O20hCINGf5T3PCG9jq0onSrm4R+Ke5CLMqMDmuU=";
  };

  patches = [
    (fetchpatch {
      name = "fix-broken-test.patch";
      url = "https://github.com/fabiocaccamo/django-maintenance-mode/commit/68cde8d9ceef00eeaa2068f420698c1c562fa9fc.patch";
      hash = "sha256-K/zYYkcnmWGc7Knz4l9PgvUtT0IccPRXc3UFriC1ldc=";
    })
  ];

  propagatedBuildInputs = [
    django
    python-fsutil
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} runtests.py

    runHook postCheck
  '';

  meta = with lib; {
    description = "Shows a 503 error page when maintenance-mode is on";
    homepage = "https://github.com/fabiocaccamo/django-maintenance-mode";
    changelog = "https://github.com/fabiocaccamo/django-maintenance-mode/releases/tag/${version}";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd3;
  };
}
