{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest-django
, pytest-xdist
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "diskcache";
  version = "5.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "grantjenks";
    repo = "python-diskcache";
    rev = "v${version}";
    hash = "sha256-c/k8mx/T4RkseDobJ2gtcuom0A6Ewyw4aP2Bk9pxV+o=";
  };

  nativeCheckInputs = [
    pytest-django
    pytest-xdist
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" tox.ini
  '';

  # Darwin sandbox causes most tests to fail
  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # Very time sensitive, can fail on over subscribed machines
    "test_incr_update_keyerror"
    # AssertionError: 'default' is not None
    "test_decr_version"
    "test_incr_version"
    "test_get_or_set"
    "test_get_many"
    # see https://github.com/grantjenks/python-diskcache/issues/260
    "test_cache_write_unpicklable_object"
  ];

  pythonImportsCheck = [
    "diskcache"
  ];

  meta = with lib; {
    description = "Disk and file backed persistent cache";
    homepage = "http://www.grantjenks.com/docs/diskcache/";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
