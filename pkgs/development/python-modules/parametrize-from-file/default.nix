{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  pytestCheckHook,
  numpy,
  decopatch,
  more-itertools,
  nestedtext,
  pyyaml,
  tidyexc,
  toml,
}:

buildPythonPackage rec {
  pname = "parametrize-from-file";
  version = "0.20.0";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "parametrize_from_file";
    hash = "sha256-t4WLNDkC/ErBnOGK6FoYIfjoL/zF9MxPThJtGM1nUL4=";
  };

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    decopatch
    more-itertools
    nestedtext
    pyyaml
    tidyexc
    toml
  ];

  pythonImportsCheck = [ "parametrize_from_file" ];

  disabledTests = [
    # https://github.com/kalekundert/parametrize_from_file/issues/19
    "test_load_suite_params_err"
  ];

  meta = with lib; {
    description = "Read unit test parameters from config files";
    homepage = "https://github.com/kalekundert/parametrize_from_file";
    changelog = "https://github.com/kalekundert/parametrize_from_file/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
