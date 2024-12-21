{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "art";
  version = "6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = "art";
    rev = "refs/tags/v${version}";
    hash = "sha256-qA1fhqNJbhSOvsPSgbnuRTs40OJsn7tYHWzujN2RVK8=";
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
    changelog = "https://github.com/sepandhaghighi/art/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
