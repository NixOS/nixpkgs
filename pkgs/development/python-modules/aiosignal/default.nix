{ lib
, buildPythonPackage
, fetchFromGitHub
, frozenlist
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiosignal";
  version = "1.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a9md2dy83qwg2an57nqrzp9nb7krq27y9zz0f7qxcrv0xd42djy";
  };

  propagatedBuildInputs = [
    frozenlist
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov=aiosignal" ""
  '';

  pythonImportsCheck = [ "aiosignal" ];

  meta = with lib; {
    description = "Python list of registered asynchronous callbacks";
    homepage = "https://github.com/aio-libs/aiosignal";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
