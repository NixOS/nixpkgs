{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# docs
, sphinx

# tests
, pytest-django
, pytestCheckHook
}:

let
  pname = "django-cache-memoize";
  version = "0.1.10";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "peterbe";
    repo = pname;
    # https://github.com/peterbe/django-cache-memoize/issues/60
    rev = "4da1ba4639774426fa928d4a461626e6f841b4f3";
    hash = "sha256-kOxtaYbKU07CPxfgE785H7VJvusQzWU5OsMWy/Ni2ek=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=cache_memoize --cov-report xml --cov-report term --cov-report html" ""
  '';

  postInstall = ''
    ${lib.getBin sphinx}/bin/sphinx-build docs $doc
  '';

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cache_memoize"
  ];

  meta = with lib; {
    description = "Django utility for a memoization decorator that uses the Django cache framework";
    homepage = "https://github.com/peterbe/django-cache-memoize";
    changelog = "https://github.com/peterbe/django-cache-memoize/blob/master/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ hexa ];
  };
}
