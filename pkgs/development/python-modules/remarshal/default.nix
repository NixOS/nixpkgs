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
  tomlkit,
  u-msgpack-python,

  # tested using
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "remarshal";
  version = "1.0.1"; # test with `nix-build pkgs/pkgs-lib/format`
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = "remarshal";
    tag = "v${version}";
    hash = "sha256-7Gng/Oc9dwtWx4Xej6hf5IuUGM9/E9Hk9QTntqWk/Z0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cbor2
    colorama
    python-dateutil
    pyyaml
    rich-argparse
    ruamel-yaml
    tomlkit
    u-msgpack-python
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/remarshal-project/remarshal/releases/tag/v${version}";
    description = "Convert between TOML, YAML and JSON";
    license = licenses.mit;
    homepage = "https://github.com/dbohdan/remarshal";
    maintainers = with maintainers; [ offline ];
    mainProgram = "remarshal";
  };
}
