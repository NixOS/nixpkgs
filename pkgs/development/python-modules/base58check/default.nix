{ lib
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "base58check";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "joeblackwaslike";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Tig6beLRDsXC//x4+t/z2BGaJQWzcP0J+QEKx3D0rhs=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "base58check"
  ];

  meta = with lib; {
    description = "Implementation of the Base58Check encoding scheme";
    homepage = "https://github.com/joeblackwaslike/base58check";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
