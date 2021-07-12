{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiolip";
  version = "1.1.4";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = pname;
    rev = version;
    sha256 = "1f8mlvbnfcn3sigsmjdpdpgxmnbvcjhfr7lzch61i8sy25dgakji";
  };

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  pythonImportsCheck = [ "aiolip" ];

  meta = with lib; {
    description = "Python module for the Lutron Integration Protocol";
    homepage = "https://github.com/bdraco/aiolip";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
