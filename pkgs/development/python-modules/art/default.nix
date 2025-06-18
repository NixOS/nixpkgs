{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "art";
  version = "6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = "art";
    tag = "v${version}";
    hash = "sha256-ub+hvxYRZznql/GZjA6QXrdHUbM+QCVEYiQfQ6IOJKE=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "art" ];

  # TypeError: art() missing 1 required positional argument: 'artname'
  checkPhase = ''
    runHook preCheck

    $out/bin/art
    $out/bin/art test
    $out/bin/art test2

    runHook postCheck
  '';

  meta = with lib; {
    description = "ASCII art library for Python";
    mainProgram = "art";
    homepage = "https://github.com/sepandhaghighi/art";
    changelog = "https://github.com/sepandhaghighi/art/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
