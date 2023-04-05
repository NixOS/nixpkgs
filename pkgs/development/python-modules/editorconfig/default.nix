{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
}:

let
  tests = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-test";
    rev = "e407c1592df0f8e91664835324dea85146f20189";
    hash = "sha256-9WSEkMJOewPqJjB6f7J6Ir0L+U712hkaN+GszjnGw7c=";
  };
in
buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.12.3";

  src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-py";
    rev = "v${version}";
    hash = "sha256-ZwoTMgk18+BpPNtXKQUMXGcl2Lp+1RQVyPHgk6gHWh8=";
    # workaround until https://github.com/editorconfig/editorconfig-core-py/pull/40 is merged
    # fetchSubmodules = true;
  };

  postUnpack = ''
    cp -r ${tests}/* source/tests
    chmod +w -R source/tests
  '';

  nativeCheckInputs = [
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
    homepage = "https://github.com/editorconfig/editorconfig-core-py";
    license = licenses.psfl;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
