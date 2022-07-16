{ lib
, buildPythonPackage
, fetchPypi
, cython
, enum34
, gfortran
, isPy27
, isPy3k
, numpy
, pytest
, python
, scipy
, sundials
}:

buildPythonPackage rec {
  pname = "scikits.odes";
  version = "2.6.4";

  disabled = isPy27;

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
  ] ++ lib.optionals (!isPy3k) [ enum34 ];

  doCheck = true;
  checkInputs = [ pytest ];

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
  };
}
