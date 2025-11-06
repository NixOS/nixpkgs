{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "conjure-python-client";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "conjure-python-client";
    tag = "${version}";
    hash = "sha256-dfoP0/v0yFAyBo4wADDGGTggVuFBoG53e5WTBvKQaS0=";
  };

  # https://github.com/palantir/conjure-python-client/blob/3.0.0/setup.py#L57
  postPatch = ''
    echo '__version__ = "${version}"' > ./conjure_python_client/_version.py
  '';

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  # some tests depend on a code generator that isn't available in nixpkgs
  # https://github.com/palantir/conjure-python-client/blob/3.0.0/CONTRIBUTING.md?plain=1#L23
  disabledTestPaths = [
    "test/conjure/test_conjure_repr.py"
    "test/integration_test"
    "test/serde/test_decode_union.py"
  ];

  pythonImportsCheck = [ "conjure_python_client" ];

  meta = {
    description = "Python client and JSON encoders for use with generated Conjure clients";
    homepage = "https://github.com/palantir/conjure-python-client";
    changelog = "https://github.com/palantir/conjure-python-client/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alkasm ];
  };
}
