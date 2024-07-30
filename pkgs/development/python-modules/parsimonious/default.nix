{
  lib,
  buildPythonPackage,
  fetchPypi,
  regex,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "parsimonious";
  version = "0.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-goFgDaGA7IrjVCekq097gr/sHj0eUvgMtg6oK5USUBw=";
  };

  propagatedBuildInputs = [ regex ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # test_benchmarks.py tests are actually benchmarks and may fail due to
    # something being unexpectedly slow on a heavily loaded build machine
    "test_lists_vs_dicts"
    "test_call_vs_inline"
    "test_startswith_vs_regex"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "regex>=2022.3.15" "regex"
  '';

  pythonImportsCheck = [
    "parsimonious"
    "parsimonious.grammar"
    "parsimonious.nodes"
  ];

  meta = with lib; {
    description = "Arbitrary-lookahead parser";
    homepage = "https://github.com/erikrose/parsimonious";
    license = licenses.mit;
    maintainers = [ ];
  };
}
