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

  patches = [
    # https://github.com/bmcage/odes/pull/205
    ./numpy24-compat.patch
  ];

  postPatch = ''
    # scipy 1.17.x's rewritten VODE integrator have bugs such as:
    # https://github.com/scipy/scipy/issues/24933
    # revisit after new scipy release
    substituteInPlace src/scikits/odes/tests/test_dae.py \
      --replace-fail "StiffVODECompare," ""
  '';

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
