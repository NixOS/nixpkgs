{ lib
, buildPythonPackage
, faker
, fetchFromGitHub
, mock
, six
, pytestCheckHook
, pythonOlder
, zstd
, stdenv
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "4.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WgtHhp7lE6StoOBfSy9+v3ODe/+zUC7lGrc2S4M68+M=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    faker
    mock
    pytestCheckHook
    zstd
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
    broken = stdenv.is32bit;
  };
}
