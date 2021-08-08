{ lib
, buildPythonPackage
, cython
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "frozenlist";
  version = "1.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "07z33vid7s8fjwvybyn8357yvs0f6nlhizv1l3qj1bczi3jbdkbh";
  };

  nativeBuildInputs = [
    cython
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=frozenlist" ""
  '';

  preBuild = ''
    cython frozenlist/_frozenlist.pyx
  '';

  pythonImportsCheck = [ "frozenlist" ];

  meta = with lib; {
    description = "Python module for list-like structure";
    homepage = "https://github.com/aio-libs/frozenlist";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
