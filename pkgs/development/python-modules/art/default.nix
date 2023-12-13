{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "art";
  version = "6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sepandhaghighi";
    repo = "art";
    rev = "v${version}";
    hash = "sha256-RJexYOGWwAwxQ7lWGgXzFSR2aly1twB9pC4QFs5m7k8=";
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
    homepage = "https://github.com/sepandhaghighi/art";
    changelog = "https://github.com/sepandhaghighi/art/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
