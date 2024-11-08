{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "py65";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mnaberez";
    repo = "py65";
    rev = "refs/tags/${version}";
    hash = "sha256-BMX+sMPx/YBFA4NFkaY0rl0EPicGHgb6xXVvLEIdllA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = {
    homepage = "https://github.com/mnaberez/py65";
    description = "Emulate 6502-based microcomputer systems in Python";
    longDescription = ''
      Py65 includes a program called Py65Mon that functions as a machine
      language monitor. This kind of program is sometimes also called a
      debugger. Py65Mon provides a command line with many convenient commands
      for interacting with the simulated 6502-based system.
    '';
    changelog = "https://github.com/mnaberez/py65/blob/${src.rev}/CHANGES.txt";
    license = lib.licenses.bsd3;
    mainProgram = "py65mon";
    maintainers = with lib.maintainers; [
      AndersonTorres
      tomasajt
    ];
  };
}
