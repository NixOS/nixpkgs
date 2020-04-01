{ lib
, buildPythonPackage
, fetchPypi
, pytest
, six
, numpy
, traitlets
}:

buildPythonPackage rec {
  pname = "numtraits";
  version = "0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fca9a6c9334f7358ef1a3e2e64ccaa6a479fc99fc096910e0d5fbe8edcdfd7e";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six numpy traitlets];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Numerical traits for Python objects";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fridh ];
    homepage = "https://github.com/astrofrog/numtraits";
  };
}
