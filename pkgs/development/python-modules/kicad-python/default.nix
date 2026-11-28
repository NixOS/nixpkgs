{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  replaceVars,
  poetry-core,
  protoletariat,
  mypy-protobuf_3_6,
  pkgs,
  protobuf,
  pynng,
  jsonschema,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,

  kicad,
}:
buildPythonPackage (finalAttrs: {
  pname = "kicad-python";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "kicad/code";
    repo = "kicad-python";
    tag = finalAttrs.version;
    hash = "sha256-Zt32e1Ib996cvE1lFEUEKcUb3rfPOfcOJu1Ikrhp7h4=";
  };

  patches = [
    (replaceVars ./use-packaged-kicad.patch {
      kicadVersion = kicad.version;
    })
  ];

  postPatch = ''
    rm -rf kicad
    ln -sfn ${kicad.src} kicad

    # fixes: FileExistsError: File already exists .../kipy/__init__.py
    substituteInPlace pyproject.toml \
      --replace-fail 'script =' "#"
  '';

  preBuild = ''
    python build.py
  '';

  build-system = [
    poetry-core
    protoletariat
  ];

  dependencies = [
    protobuf
    pynng
    jsonschema
  ]
  ++ (lib.optional (pythonOlder "3.13") typing-extensions);

  nativeBuildInputs = [
    pkgs.protobuf
    mypy-protobuf_3_6
  ];

  pythonRelaxDeps = [ "protobuf" ];

  pythonImportsCheck = [ "kipy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "KiCad API Python Bindings";
    homepage = "https://kicad.org/";
    downloadPage = "https://gitlab.com/kicad/code/kicad-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sigmanificient
      ryand56
    ];
  };
})
