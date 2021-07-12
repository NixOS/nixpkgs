{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hsluv";
  version = "5.0.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "hsluv";
    repo = "hsluv-python";
    rev = "v${version}";
    sha256 = "0r0w8ycjwfg3pmzjghzrs0lkam93fzvgiqvrwh3nl9jnqlpw7v7j";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hsluv" ];

  meta = with lib; {
    description = "Python implementation of HSLuv";
    homepage = "https://github.com/hsluv/hsluv-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
