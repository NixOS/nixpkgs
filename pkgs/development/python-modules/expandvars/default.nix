{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # build-system
  hatchling,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "expandvars";
  version = "1.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mK3YJot2Df7kV73hwXv3RXlf3rwit92rdf0yeGU/HgU=";
  };

  patches = [
    (fetchpatch {
      name = "pytest9-compat.patch";
      url = "https://github.com/sayanarijit/expandvars/commit/0ab5747185be9135b0711e72fc64dfa6a33f3fd3.patch";
      hash = "sha256-raO5dGbcXb0adUCeHmnWp49vpIMllRW9Ow8rG4OH+Hs=";
    })
  ];

  nativeBuildInputs = [ hatchling ];

  pythonImportsCheck = [ "expandvars" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  meta = {
    description = "Expand system variables Unix style";
    homepage = "https://github.com/sayanarijit/expandvars";
    license = lib.licenses.mit;
  };
}
