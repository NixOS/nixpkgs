{
  lib,
  fetchFromGitLab,
  python3,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication {
  pname = "yaookctl";
  version = "0-unstable-2026-07-16";

  src = fetchFromGitLab {
    owner = "yaook";
    repo = "yaookctl";
    rev = "2082bdb4da0f927372e2c7fdb3c27bc9970e0747";
    hash = "sha256-/SXBwHO3Tf3YaefgFrvH0oc6+mYHjE9RySt7vLQuoiQ=";
  };

  __structuredAttrs = true;

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

  # Try to import all submodules in order to get warned of new dependencies
  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -c "
      import pkgutil, importlib
      import yaookctl
      for _, name, _ in pkgutil.walk_packages(yaookctl.__path__, yaookctl.__name__ + '.'):
          if name.endswith('.__main__'):
              continue
          importlib.import_module(name)
    "
    runHook postCheck
  '';

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
