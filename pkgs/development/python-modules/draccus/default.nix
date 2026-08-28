{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  mergedeep,
  pyyaml,
  toml,
  typing-inspect,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "draccus";
  version = "0.11.6";
  pyproject = true;

  # No (recent) tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0TT1dqH0/r2TxrIA33+S5f6//p79wKXzgb9QwuBWijk=";
  };

  patches = [
    (fetchpatch2 {
      # TODO: remove when updating to the next release
      # Removes the pyyaml-include~=1.4 dependency
      # https://github.com/dlwh/draccus/issues/46#issuecomment-3180810991
      name = "remove-pyyaml-include-dep.patch";
      url = "https://github.com/dlwh/draccus/commit/3a6db0bc786e46cc13c481bc2235101d7a411441.patch";
      hash = "sha256-0OLUjXJSZ9eIL8dgE8o1Mg0HIMX+4XABSf0tYNFWn8I=";
    })
  ];

  # Pass non-callable type= (typing.Union, X | Y) through argparse.
  postPatch = ''
    substituteInPlace draccus/wrappers/field_wrapper.py \
      --replace-fail '_arg_options["type"] = tpe' \
                     '_arg_options["type"] = tpe if callable(tpe) else str'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    mergedeep
    pyyaml
    toml
    typing-inspect
  ];

  pythonImportsCheck = [ "draccus" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Framework for simple dataclass-based configurations based on Pyrallis";
    homepage = "https://github.com/dlwh/draccus";
    changelog = "https://github.com/marin-community/draccus/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
