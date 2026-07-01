{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build deps
  poetry-core,

  # propagates
  cbor2,
  colorama,
  python-dateutil,
  pyyaml,
  rich-argparse,
  ruamel-yaml,
  tomli,
  tomlkit,
  u-msgpack-python,

  # tested using
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "remarshal";
  version = "1.3.0"; # test with `nix-build pkgs/pkgs-lib/format`
  pyproject = true;

  src = fetchFromGitHub {
    owner = "remarshal-project";
    repo = "remarshal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/K8x6ij23pk5O1+XJdFHaGbZ47nFMbXzp+4UMO5dGp4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cbor2
    colorama
    python-dateutil
    pyyaml
    rich-argparse
    ruamel-yaml
    tomli
    tomlkit
    u-msgpack-python
  ];

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
