{ lib
, fetchFromGitHub
, buildPythonPackage
, wxPython_4_0
, python
}:

buildPythonPackage rec {
  pname = "humblewx";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "thetimelineproj";
    repo = pname;
    rev = version;
    sha256 = "0fv8gwlbcj000qq34inbwgxf0xgibs590dsyqnw0mmyb7f1iq210";
  };

  # timeline is not compatible with wxPython_4_1. reported upstream
  propagatedBuildInputs = [ wxPython_4_0 ];

  checkPhase = ''
    runHook preCheck
    for i in examples/*; do
      ${python.interpreter} $i
    done
    runHook postCheck
  '';

  # Unable to access the X Display, is $DISPLAY set properly?
  # would have to use nixos module tests, but it is not worth it
  doCheck = false;

  pythonImportsCheck = [ "humblewx" ];

  meta = {
    homepage = "https://github.com/thetimelineproj/humblewx";
    description = "Library that simplifies creating user interfaces with wxPython";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ davidak ];
  };
}
