{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  discordpy,
  click,
  braceexpand,
  import-expression,
  tabulate,
  pytestCheckHook,
  pytest-asyncio,
  youtube-dl,
  unstableGitUpdater,
}:

buildPythonPackage rec {
  pname = "jishaku";
  version = "2.5.1-unstable-2024-05-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Gorialis";
    repo = "jishaku";
    rev = "f68f4395cc58fca247b86967b52b35d95f2b7cd3";
    hash = "sha256-1FBQNUC+qXBHWcY/7h2Rvw1anTD5BTYY/yAm+QnBlaQ=";
  };

  postPatch = ''
    substituteInPlace jishaku/shell.py \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    discordpy
    click
    braceexpand
    tabulate
    import-expression
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    youtube-dl
  ];

  pythonImportsCheck = [
    "jishaku"
    "jishaku.repl"
    "jishaku.features"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A debugging and testing cog for discord.py bots";
    homepage = "https://jishaku.readthedocs.io/en/latest";
    changelog = "https://github.com/Gorialis/jishaku/releases/tag/${version}";
    maintainers = with lib.maintainers; [ lychee ];
    mainProgram = "jishaku";
    license = lib.licenses.mit;
  };
}
