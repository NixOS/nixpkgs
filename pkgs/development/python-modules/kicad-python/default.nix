{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  poetry-core,
  protoletariat,
  mypy-protobuf,
  pkgs,
  protobuf,
  pynng,
  pytestCheckHook,
  gitMinimal,
  pythonOlder,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "kicad-python";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kicad/code";
    repo = "kicad-python";
    tag = finalAttrs.version;
    hash = "sha256-FIWTYBUauq4yUdnijjPgxaXynh/U03ppnLU8YVkKYHw=";
    fetchSubmodules = true;
  };

  build-system = [
    poetry-core
    protoletariat
  ];

  dependencies = [
    protobuf
    pynng
    mypy-protobuf
  ]
  ++ (lib.optional (pythonOlder "3.13") typing-extensions);

  nativeBuildInputs = [
    pkgs.protobuf
    mypy-protobuf
    gitMinimal
  ];

  pythonRelaxDeps = [ "protobuf" ];

  # fixes: FileExistsError: File already exists .../kipy/__init__.py
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'script =' "#"
  '';

  preBuild = ''
    python build.py
  '';

  pythonImportsCheck = [ "kipy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "KiCad API Python Bindings";
    homepage = "https://kicad.org/";
    downloadPage = "https://gitlab.com/kicad/code/kicad-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
