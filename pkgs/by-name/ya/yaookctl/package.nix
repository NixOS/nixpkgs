{
  lib,
  fetchFromGitLab,
  python3,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication {
  pname = "yaookctl";
<<<<<<< HEAD
  version = "0-unstable-2025-12-12";
=======
  version = "0-unstable-2025-11-18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "yaook";
    repo = "yaookctl";
<<<<<<< HEAD
    rev = "94215db203cd8e471616d557cd83d71f0bc9918d";
    hash = "sha256-rAd69fJQSqo6Xe0yL4CmPn0/HmygWkojwBXPEOAY1dE=";
=======
    rev = "cc339565b136ec9bad36f9eb3dc1b3da728cc0ec";
    hash = "sha256-9UCF1qo6OOfOBoWqsQMxlHZNJD7OQnSFONJ+cXT0LUs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pyproject = true;
  build-system = [ python3.pkgs.setuptools ];

  dontCheckRuntimeDeps = true;

  dependencies = with python3.pkgs; [
    babel
    click
    click-option-group
    kubernetes-asyncio
    prettytable
    typing-extensions
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://gitlab.com/yaook/yaookctl";
    description = "Toolbox for interacting with Yaook clusters";
    license = lib.licenses.mit;
    mainProgram = "yaookctl";
    maintainers = with lib.maintainers; [ lykos153 ];
  };
}
