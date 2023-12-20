{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, python
, coverage
, buildPackages
}:

buildPythonPackage rec {
  version = "1.3.7";
  format = "setuptools";
  pname = "nose";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98";
  };

  # 2to3 was removed in setuptools 58
  postPatch = ''
    substituteInPlace setup.py \
      --replace "'use_2to3': True," ""

    substituteInPlace setup3lib.py \
      --replace "from setuptools.command.build_py import Mixin2to3" "from distutils.util import Mixin2to3"
  '';

  preBuild = lib.optionalString (isPy3k) ''
    ${python.pythonOnBuildForHost}/bin/2to3 -wn nose functional_tests unit_tests
  '';

  propagatedBuildInputs = [ coverage ];

  doCheck = false; # lot's of transient errors, too much hassle
  checkPhase = if isPy3k then ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_tests
  '' else "" + ''
    rm functional_tests/test_multiprocessing/test_concurrent_shared.py* # see https://github.com/nose-devs/nose/commit/226bc671c73643887b36b8467b34ad485c2df062
    ${python.pythonOnBuildForHost.interpreter} selftest.py
  '';

  meta = with lib; {
    broken = isPyPy; # missing 2to3 conversion utility
    description = "A unittest-based testing framework for python that makes writing and running tests easier";
    homepage = "https://nose.readthedocs.io/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ ];
  };
}
