{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build deps
  poetry-core,

  # propagates
  cbor2,
  colorama,
  ruamel-yaml,
  starlark,
  termcolor,
  tomli,
  tomlkit,
  u-msgpack-python,

  # tested using
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "remarshal";
  version = "2.1.3"; # test with `nix-build pkgs/pkgs-lib/tests -A formats`
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remarshal-project";
    repo = "remarshal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n+V2+xSzrBH58F10yKhDiCLvQmlPfDx6rP+ysEGpZg4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cbor2
    colorama
    ruamel-yaml
    starlark
    termcolor
    tomli
    tomlkit
    u-msgpack-python
  ];

  pythonRelaxDeps = [ "cbor2" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/${finalAttrs.src.tag}";
    description = "Convert between TOML, YAML and JSON";
    license = lib.licenses.mit;
    homepage = "https://github.com/remarshal-project/remarshal";
    maintainers = [ ];
    mainProgram = "remarshal";
  };
})
