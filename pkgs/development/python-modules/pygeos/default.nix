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
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MPvBf2SEQgC4UTO4hfz7ZVQbh3lTH270+P5GfT+6diM=";
  };

  nativeBuildInputs = [
    geos # for geos-config
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # The cythonized extensions are required to exist in the pygeos/ directory
  # for the package to function. Therefore override of buildPhase was
  # necessary.
  buildPhase = ''
    ${python.pythonForBuild.interpreter} setup.py build_ext --inplace
    ${python.pythonForBuild.interpreter} setup.py bdist_wheel
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pygeos"
  ];

  meta = with lib; {
    description = "Wraps GEOS geometry functions in numpy ufuncs";
    homepage = "https://github.com/pygeos/pygeos";
    changelog = "https://github.com/pygeos/pygeos/blob/${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nialov ];
  };
}
