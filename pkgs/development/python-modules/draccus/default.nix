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
  version = "0.11.5";
  pyproject = true;

  # No (recent) tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uC4sICcDCuGg8QVRUSX5FOBQwHZqtRjfOgVgoH0Q3ck=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
