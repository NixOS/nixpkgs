{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchurl
, cython
, enum34
, gfortran
, isPy3k
, numpy
, pytest
, python
, scipy
, sundials
}:

buildPythonPackage rec {
  pname = "scikits.odes";
  version = "2.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kbf2n16h9s35x6pavlx6sff0pqr68i0x0609z92a4vadni32n6b";
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

  meta = with stdenv.lib; {
    description = "A scikit offering extra ode/dae solvers, as an extension to what is available in scipy";
    homepage = https://github.com/bmcage/odes;
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    platforms = [ "aarch64-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
