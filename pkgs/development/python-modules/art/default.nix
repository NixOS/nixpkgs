{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "art";
  version = "6.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = "art";
    rev = "refs/tags/v${version}";
    hash = "sha256-lFe6J3R+A1WE+LGywupjOGwhOcrUH5JE26Cit0DaT/4=";
  };

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
