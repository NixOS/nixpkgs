{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pymemcache";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "pinterest";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ajlhirxhd4pbzgd84k44znjazjbnbdfm3sk64avs0vgcgclq2n7";
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
