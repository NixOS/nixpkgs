{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,

  # build-system
  mypy-protobuf_3_6,
  poetry-core,
  protoletariat,

  # dependencies
  protobuf,
  pynng,
  pythonOlder,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "atopile-kicad-python";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "atopile";
    repo = "kicad-python";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Qs0xnq+dcgm6U4i2vvyC05Am76/njwgk8P7zeXoawqg=";
  };

  # The repo declares itself as "kicad-python" 0.6.0.dev0; atopile only renames
  # it to atopile-kicad-python at PyPI publish time. Match that for dependents.
  # Disabling the build script fixes: FileExistsError: File already exists .../kipy/__init__.py
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        'name = "kicad-python"' \
        'name = "atopile-kicad-python"' \
      --replace-fail \
        'version = "0.6.0.dev0"' \
        'version = "${finalAttrs.version}"' \
      --replace-fail \
        'script =' \
        "#"
  '';

  build-system = [
    poetry-core
    protoletariat
  ];

  nativeBuildInputs = [
    mypy-protobuf_3_6
    pkgs.protobuf
  ];

  # Generate the protobuf bindings
  preBuild = ''
    python build.py
  '';

  pythonRelaxDeps = [ "protobuf" ];
  dependencies = [
    protobuf
    pynng
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    typing-extensions
  ];

  pythonImportsCheck = [ "kipy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "KiCad API Python Bindings (atopile fork)";
    homepage = "https://github.com/atopile/kicad-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thecodedkid ];
  };
})
