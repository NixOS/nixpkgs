{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DKqfv5gf9gzbnEPQSzy2mAaVYJZL9jmTKyGWVzj40T4=";
  };

  checkInputs = [
    future
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

  pythonImportsCheck = [ "pymemcache" ];

  meta = with lib; {
    description = "Python memcached client";
    homepage = "https://pymemcache.readthedocs.io/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
