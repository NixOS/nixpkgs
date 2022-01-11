{ lib
, buildPythonPackage
, fetchgit
, cmake
}:

buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.12.3";

  # fetchgit used to ensure test submodule is available
  src = fetchgit {
    url = "https://github.com/editorconfig/editorconfig-core-py";
    rev = "1a8fb62b9941fded9e4fb83a3d0599427f5484cb"; # Not tagged
    sha256 = "0vx8rl7kii72965jsi01mdsz9rfi1q9bwy13x47iaqm6rmcwc1rb";
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
