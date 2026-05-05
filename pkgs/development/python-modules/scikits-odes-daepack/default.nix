{
  buildPythonPackage,
  gfortran,
  meson-python,
  numpy,
  scikits-odes-core,
}:

buildPythonPackage rec {
  inherit (scikits-odes-core) version src;
  pname = "scikits-odes-daepack";
  pyproject = true;

  sourceRoot = "${src.name}/packages/scikits-odes-daepack";

  build-system = [
    meson-python
    numpy
  ];

  nativeBuildInputs = [ gfortran ];

  dependencies = [
    numpy
    scikits-odes-core
  ];

  pythonImportsCheck = [ "scikits_odes_daepack" ];

  # no tests
  doCheck = false;

  # https://github.com/bmcage/odes/pull/204
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  meta = scikits-odes-core.meta // {
    description = "Wrapper around daepack";
    homepage = "https://github.com/bmcage/odes/blob/master/packages/scikits-odes-daepack";
  };
}
