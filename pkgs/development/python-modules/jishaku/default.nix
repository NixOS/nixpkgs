{
  lib,
  bash,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  discordpy,
  click,
  braceexpand,
  import-expression,
  tabulate,
  pytestCheckHook,
  pytest-asyncio,
  youtube-dl,
}:
buildPythonPackage rec {
  pname = "jishaku";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Gorialis";
    repo = "jishaku";
    tag = version;
    hash = "sha256-+J8Tr8jPN9K3eHLOuJTaP3We5A1kiyn9/yI1KChbuMY=";
  };

  patches = [
    (fetchpatch {
      # add entrypoint for install script
      url = "https://github.com/Gorialis/jishaku/commit/b96cd55a1c2fd154c548f08019ccd6f7be9c7f90.patch";
      hash = "sha256-laPoupwCC1Zthib8G+c1BXqTwZK0Z6up1DKVkhFicJ0=";
    })
  ];

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

  meta = {
    description = "Debugging and testing cog for discord.py bots";
    homepage = "https://jishaku.readthedocs.io/en/latest";
    changelog = "https://github.com/Gorialis/jishaku/releases/tag/${src.tag}";
    maintainers = [ ];
    mainProgram = "jishaku";
    license = lib.licenses.mit;
  };
}
