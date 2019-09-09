{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, cython
, enum34
, gfortran
, isPy3k
, numpy
, pytest
, python
, scipy
, sundials_3
}:

buildPythonPackage rec {
  pname = "scikits.odes";
  version = "2.4.0-9-g93075ae";

  # we fetch github instead of Pypi, as we want #104 and #105, which don't apply cleanly on 2.4.0
  src = fetchFromGitHub {
    owner = "bmcage";
    repo = "odes";
    rev = "93075ae25c409f572f13ca7207fada5706f73c73";
    sha256 = "161rab7hy6r1a9xw1zby9xhnnmxi0zwdpzxfpjkw9651xn2k5xyw";
  };

  nativeBuildInputs = [
    gfortran
    cython
  ];

  propagatedBuildInputs = [
    numpy
    sundials_3
    scipy
  ] ++ lib.optionals (!isPy3k) [ enum34 ];

  doCheck = true;
  checkInputs = [ pytest ];

  checkPhase = ''
    cd $out/${python.sitePackages}/scikits/odes/tests
    pytest
  '';

  meta = with stdenv.lib; {
    description = "A scikit offering extra ode/dae solvers, as an extension to what is available in scipy";
    homepage = https://github.com/bmcage/odes;
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    platforms = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
