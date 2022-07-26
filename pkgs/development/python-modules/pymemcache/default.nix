{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, six
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "3.5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bsiFWZHGJO/07w6mFXzf0JwftJWClE2mTv86h8zT1K0=";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  disabledTests = [
    # python-memcached is not available (last release in 2017)
    "TestClientSocketConnect"
  ];

  pythonImportsCheck = [
    "pymemcache"
  ];

  meta = with lib; {
    description = "Python memcached client";
    homepage = "https://pymemcache.readthedocs.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
