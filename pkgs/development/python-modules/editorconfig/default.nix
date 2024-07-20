{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cmake,
}:

buildPythonPackage rec {
  pname = "editorconfig";
  version = "0.12.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "editorconfig";
    repo = "editorconfig-core-py";
    rev = "v${version}";
    hash = "sha256-+m674bLj6xs7MWU+8BMixEwy7/TjyES0lvCLLogTDHQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ setuptools ];

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
