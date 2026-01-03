{
  buildPythonPackage,
  sundials,
  cython,
  numpy,
  pkgconfig,
  setuptools,
  scikits-odes-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (scikits-odes-core) version src;
  pname = "scikits-odes-sundials";
  pyproject = true;

  sourceRoot = "${src.name}/packages/scikits-odes-sundials";

  build-system = [
    cython
    numpy
    pkgconfig
    setuptools
  ];

  buildInputs = [ sundials ];

  dependencies = [
    numpy
    scikits-odes-core
  ];

  pythonImportsCheck = [ "scikits_odes_sundials" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = scikits-odes-core.meta // {
    description = "Sundials wrapper module for scikits-odes";
    homepage = "https://github.com/bmcage/odes/blob/master/packages/scikits-odes-sundials";
  };
}
