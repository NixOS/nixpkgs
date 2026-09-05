{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asn1";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "andrivet";
    repo = "python-asn1";
    tag = "v${version}";
    hash = "sha256-DLKfdQzYLhfaIEPPymTzRqj3+L/fsm5Jh8kqud/ezfw=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "enum-compat" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/test_asn1.py" ];

  pythonImportsCheck = [ "asn1" ];

  meta = {
    description = "Python ASN.1 encoder and decoder";
    longDescription = ''
      Kept for consumers that cannot use asn1 3.x, where Decoder.read() returns
      recursively decoded values for constructed tags instead of the raw contents.
    '';
    homepage = "https://github.com/andrivet/python-asn1";
    changelog = "https://github.com/andrivet/python-asn1/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
