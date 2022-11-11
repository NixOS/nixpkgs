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
  version = "0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HDcweKrVou/tHDnNcceXqiAzvzCH8191FrrIm+ULmGE=";
  };

  patches = [
    # Adapt https://github.com/shapely/shapely/commit/4889bd2d72ff500e51ba70d5b954241878349562,
    # backporting to pygeos
    ./fix-for-geos-3-11.patch
  ];

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

