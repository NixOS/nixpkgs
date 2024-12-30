{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cmake,
}:

buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-py";
    rev = "v${version}";
    hash = "sha256-vYuXW+Yb0GXZAwaarV4WBIJtS31+EleiddU9ibBn/hs=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ cmake ];

  dontUseCmakeConfigure = true;

  checkPhase = ''
    runHook preCheck

    cmake .
    ctest .

    runHook postCheck
  '';

  pythonImportsCheck = [ "editorconfig" ];

  meta = with lib; {
    description = "EditorConfig File Locator and Interpreter for Python";
    mainProgram = "editorconfig";
    homepage = "https://github.com/editorconfig/editorconfig-core-py";
    license = licenses.psfl;
    maintainers = with maintainers; [ nickcao ];
  };
}
