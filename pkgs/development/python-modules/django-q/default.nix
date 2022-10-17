{ arrow
, blessed
, buildPythonPackage
, croniter
, django
, django-redis
, django-picklefield
, fetchFromGitHub
, future
, lib
, poetry-core
, pytest-django
, pytest-mock
, pytestCheckHook
, pkgs
, stdenv
}:

buildPythonPackage rec {
  pname = "django-q";
  version = "1.3.9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Koed00";
    repo = "django-q";
    sha256 = "sha256-gFSrAl3QGoJEJfvTTvLQgViPPjeJ6BfvgEwgLLo+uAA=";
    rev = "v${version}";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    django-picklefield
    arrow
    blessed
    django
    future
  ];

  # fixes empty version string
  # analog to https://github.com/NixOS/nixpkgs/pull/171200
  patches = [
    ./pep-621.patch
  ];

  pythonImportsCheck = [
    "django_q"
  ];

  preCheck = ''
    ${pkgs.redis}/bin/redis-server &
    REDIS_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
  '';

  checkInputs = [
    croniter
    django-redis
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  # don't bother with two more servers to test
  disabledTests = [
    "test_disque"
    "test_mongo"
  ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A multiprocessing distributed task queue for Django";
    homepage = "https://django-q.readthedocs.org";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
