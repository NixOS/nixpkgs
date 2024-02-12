{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pytestCheckHook
, cython
, toolz
, python
, isPy27
}:

buildPythonPackage rec {
  pname = "cytoolz";
  version = "0.12.2";
  format = "setuptools";
  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MdSwRV1y2RRkX4A9kX2vTzFNEVxw3gV404IN64sQH2Y=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ toolz ];

  # tests are located in cytoolz/tests, however we can't import cytoolz
  # from $PWD, as it will break relative imports
  preCheck = ''
    cd cytoolz
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
