{ lib
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, marshmallow-enum
, pytestCheckHook
, pythonOlder
, typeguard
, typing-inspect
}:

buildPythonPackage rec {
  pname = "marshmallow-dataclass";
  version = "8.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "lovasoa";
    repo = "marshmallow_dataclass";
    rev = "v${version}";
    sha256 = "0mngkjfs2nxxr0y77n429hb22rmjxbnn95j4vwqr9y6q16bqxs0w";
  };

  propagatedBuildInputs = [
    marshmallow
    typing-inspect
  ];

  checkInputs = [
    marshmallow-enum
    pytestCheckHook
    typeguard
  ];

  pythonImportsCheck = [ "marshmallow_dataclass" ];

  meta = with lib; {
    description = "Automatic generation of marshmallow schemas from dataclasses";
    homepage = "https://github.com/lovasoa/marshmallow_dataclass";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
