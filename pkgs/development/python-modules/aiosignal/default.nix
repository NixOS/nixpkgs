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
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pamfc2l95s1q86jvmbp17chjy129gk01kwy8xm88d2ijy8s1caq";
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
      --replace "filterwarnings = error" "" \
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
