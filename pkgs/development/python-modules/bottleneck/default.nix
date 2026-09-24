{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  versioneer,
  numpy,
  pytestCheckHook,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "bottleneck";
  version = "1.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ao1G7ksCWtmrTXmSQROBb4JfYrF7h8nh0NjOFEpKDjE=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = "pushd $out";
  postCheck = "popd";

  pythonImportsCheck = [ "bottleneck" ];

  meta = {
    description = "Fast NumPy array functions";
    homepage = "https://github.com/pydata/bottleneck";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
