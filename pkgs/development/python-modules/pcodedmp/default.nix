{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pcodedmp";
  version = "1.2.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bontchev";
    repo = "pcodedmp";
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

  meta = {
    description = "Python VBA p-code disassembler";
    mainProgram = "pcodedmp";
    homepage = "https://github.com/bontchev/pcodedmp";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
