{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pcodedmp";
  version = "1.2.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bontchev";
    repo = pname;
    rev = version;
    hash = "sha256-SYOFGMvrzxDPMACaCvqwU28Mh9LEuvFBGvAph4X+geo=";
  };

  postPatch = ''
    # Circular dependency
    substituteInPlace setup.py \
      --replace "'oletools>=0.54'," ""
  '';

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pcodedmp" ];

  meta = with lib; {
    description = "Python VBA p-code disassembler";
    mainProgram = "pcodedmp";
    homepage = "https://github.com/bontchev/pcodedmp";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
