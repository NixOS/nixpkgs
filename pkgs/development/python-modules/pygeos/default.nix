{ lib
, buildPythonPackage
, fetchPypi
, python
, geos
, pytestCheckHook
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "pygeos";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PEFULvZ8ZgFfRDrj5uaDUDqKIh+cJPsjgPauQq7RYAo=";
  };

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  propagatedBuildInputs = [ numpy ];

  # The cythonized extensions are required to exist in the pygeos/ directory
  # for the package to function. Therefore override of buildPhase was
  # necessary.
  buildPhase = ''
    ${python.interpreter} setup.py build_ext --inplace
    ${python.interpreter} setup.py bdist_wheel
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pygeos" ];

  meta = with lib; {
    description = "Wraps GEOS geometry functions in numpy ufuncs.";
    homepage = "https://github.com/pygeos/pygeos";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nialov ];
  };
}

