{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  scipy,
  scikits-odes-core,
  scikits-odes-daepack,
  scikits-odes-sundials,
  pytestCheckHook,
}:

buildPythonPackage rec {
  inherit (scikits-odes-core) version src;
  pname = "scikits.odes";
  pyproject = true;

  sourceRoot = "${src.name}/packages/scikits-odes";

  build-system = [ setuptools ];

  dependencies = [
    scipy
    scikits-odes-core
    scikits-odes-daepack
    scikits-odes-sundials
  ];

  pythonImportsCheck = [ "scikits_odes" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isAarch64 [
    # skip on aarch64, see https://github.com/bmcage/odes/issues/101
    "test_lsodi"
  ];

  meta = scikits-odes-core.meta // {
    description = "Scikit offering extra ode/dae solvers, as an extension to what is available in scipy";
    homepage = "https://github.com/bmcage/odes/blob/master/packages/scikits-odes";
  };
}
