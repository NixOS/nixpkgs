{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xkw76y4059jg2a902wlpk6psyh2g4x6j6vlj9gzd5vqb7ihg2y7";
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
