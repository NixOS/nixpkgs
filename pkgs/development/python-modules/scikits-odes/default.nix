{ lib
, buildPythonPackage
, fetchPypi
, cython
, gfortran
, numpy
, pytest
, python
, scipy
, sundials
}:

buildPythonPackage rec {
  pname = "scikits.odes";
  version = "2.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fS9E0kO+ZEcGjiWQPAQHa52zOz9RafNSBPNKypm0GhA=";
  };

  nativeBuildInputs = [
    gfortran
    cython
  ];

  propagatedBuildInputs = [
    numpy
    sundials
    scipy
  ];

  checkInputs = [ pytestCheckHook ];

  doCheck = true;

  checkPhase = ''
    cd $out/${python.sitePackages}/scikits/odes/tests
    pytest
  '';

  meta = with lib; {
    description = "A scikit offering extra ode/dae solvers, as an extension to what is available in scipy";
    homepage = "https://github.com/bmcage/odes";
    license = licenses.bsd3;
    maintainers = with maintainers; [ idontgetoutmuch ];
    platforms = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
    # Build fails with sundials 6.3.0
    # https://github.com/bmcage/odes/issues/138
    broken = true;
  };
}
