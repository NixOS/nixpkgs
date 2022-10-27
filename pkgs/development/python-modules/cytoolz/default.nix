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
  version = "0.12.0";
  disabled = isPy27 || isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wQWwX4XgP7zWAkQ3WWjmLkT+eYwVo1Mcki1TEBjSJBI=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ toolz ];

  # tests are located in cytoolz/tests, however we can't import cytoolz
  # from $PWD, as it will break relative imports
  preCheck = ''
    cd cytoolz
    export PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH
  '';

  checkInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://github.com/pytoolz/cytoolz/";
    description = "Cython implementation of Toolz: High performance functional utilities";
    license = "licenses.bsd3";
    maintainers = with lib.maintainers; [ fridh ];
  };
}
