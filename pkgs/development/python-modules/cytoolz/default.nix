{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pytestCheckHook,
  cython,
  setuptools,
  toolz,
  python,
  isPy27,
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.12.3";
  pyproject = true;

  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RQPcWfTO1TpUZDJyxh3DBdHbv719a98paUjenzTDooI=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [ toolz ];

  # tests are located in cytoolz/tests, however we can't import cytoolz
  # from $PWD, as it will break relative imports
  preCheck = ''
    cd cytoolz
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  disabledTests = [
    # https://github.com/pytoolz/cytoolz/issues/200
    "test_inspect_wrapped_property"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = licenses.bsd3;
  };
}
