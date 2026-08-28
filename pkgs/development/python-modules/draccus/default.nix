{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  mergedeep,
  pyyaml,
  toml,
  typing-inspect,

  # tests
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "draccus";
  version = "0.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marin-community";
    repo = "draccus";
    tag = "v${version}";
    hash = "sha256-L9lvMjd76jm9ZIq5Pl2EOVQP2r4ReWQUOUGOPXDVfEI=";
  };

  # Pass non-callable type= (typing.Union, X | Y) through argparse.
  postPatch = ''
    substituteInPlace draccus/wrappers/field_wrapper.py \
      --replace-fail '_arg_options["type"] = tpe' \
                     '_arg_options["type"] = tpe if callable(tpe) else str'
  '';

  build-system = [ setuptools ];

  dependencies = [
    mergedeep
    pyyaml
    toml
    typing-inspect
  ];

  pythonImportsCheck = [ "draccus" ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  meta = {
    description = "Framework for simple dataclass-based configurations based on Pyrallis";
    homepage = "https://github.com/marin-community/draccus";
    changelog = "https://github.com/marin-community/draccus/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
