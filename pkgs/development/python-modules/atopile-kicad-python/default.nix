{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  protoletariat,
  mypy-protobuf_3_6,
  pkgs,
  protobuf,
  pynng,
  pytestCheckHook,
  gitMinimal,
  pythonOlder,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "atopile-kicad-python";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "kicad-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qs0xnq+dcgm6U4i2vvyC05Am76/njwgk8P7zeXoawqg=";
    fetchSubmodules = true;
  };

  build-system = [
    poetry-core
    protoletariat
  ];

  dependencies = [
    protobuf
    pynng
  ]
  ++ (lib.optional (pythonOlder "3.13") typing-extensions);

  nativeBuildInputs = [
    pkgs.protobuf
    mypy-protobuf_3_6
    gitMinimal
  ];

  pythonRelaxDeps = [ "protobuf" ];

  # The repo declares itself as "kicad-python" 0.6.0.dev0; atopile only renames
  # it to atopile-kicad-python ${finalAttrs.version} at PyPI publish time. Match
  # that so dependents resolving "atopile-kicad-python" find it.
  # Also fixes: FileExistsError: File already exists .../kipy/__init__.py
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'name = "kicad-python"' 'name = "atopile-kicad-python"' \
      --replace-fail 'version = "0.6.0.dev0"' 'version = "${finalAttrs.version}"' \
      --replace-fail 'script =' "#"
  '';

  preBuild = ''
    python build.py
  '';

  pythonImportsCheck = [ "kipy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "KiCad API Python Bindings (atopile fork)";
    homepage = "https://github.com/atopile/kicad-python";
    downloadPage = "https://github.com/atopile/kicad-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
