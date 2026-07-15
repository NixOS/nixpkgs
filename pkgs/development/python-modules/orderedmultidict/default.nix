{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "orderedmultidict";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gruns";
    repo = "orderedmultidict";
    # https://github.com/gruns/orderedmultidict/issues/32
    rev = "901194bed9c2de9e336358f3328132a81a14314e";
    hash = "sha256-XJKmchG3BmPKrw20BEMLe2V6XlN9tXcgkf5G+P97uAQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  pythonImportsCheck = [ "orderedmultidict" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Ordered Multivalue Dictionary";
    homepage = "https://github.com/gruns/orderedmultidict";
    license = lib.licenses.unlicense;
  };
})
