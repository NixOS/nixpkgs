{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-py";
    rev = "v${version}";
    sha256 = "sha256-KwfGWc2mYhUP6SN4vhIO0eX0dasBRC2LSeLEOA/NqG8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  dontUseCmakeConfigure = true;

  checkPhase = ''
    cmake .
    # utf_8_char fails with Python 3
    ctest -E "utf_8_char" .
  '';

  pythonImportsCheck = [ "editorconfig" ];

  meta = with lib; {
    description = "EditorConfig File Locator and Interpreter for Python";
    homepage = "https://editorconfig.org";
    license = licenses.psfl;
    maintainers = with maintainers; [ ];
  };
}
