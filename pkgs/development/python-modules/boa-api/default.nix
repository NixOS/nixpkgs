{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "boa-api";
  version = "0.1.14";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "boalang";
    repo = "api-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tt68NLi5ewSKiHdu3gDawTBPylbDmB4zlUUqa7EQuY=";
  };

  build-system = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "boaapi" ];

  meta = {
    homepage = "https://github.com/boalang/api-python";
    description = "Python client API for communicating with Boa's (https://boa.cs.iastate.edu/) XML-RPC based services";
    changelog = "https://github.com/boalang/api-python/blob/${finalAttrs.src.rev}/Changes.txt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ swflint ];
  };
})
