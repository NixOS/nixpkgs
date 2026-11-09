{
  lib,
  angr,
  buildPythonPackage,
  fetchFromGitHub,
  pwntools,
  setuptools,
  tqdm,
}:

buildPythonPackage {
  pname = "angrop";
  version = "9.2.12.post3-unstable-2026-09-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angrop";
    rev = "e8519dc4ca294ad4cf44fd0376545c3740647330";
    hash = "sha256-W9B0oPdLfWRfVLZ9/w/tEN9k7zeu+KtoxILe2cfLvd8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    angr
    pwntools
    tqdm
  ];

  # Tests require external binary fixtures.
  doCheck = false;

  pythonImportsCheck = [
    "angrop"
    "angrop.angrop_cli"
  ];

  meta = {
    description = "ROP gadget finder and chain builder";
    homepage = "https://github.com/angr/angrop";
    mainProgram = "angrop-cli";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
}
