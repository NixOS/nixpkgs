{ lib
, buildPythonPackage
, fetchPypi
, pytools
, pytest
, six
, sympy
, pexpect
, symengine
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2021.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "67d08ef95568408901e59f79591ba41fd3f2caaecb42b7497c38fc82fd60358c";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"pytest>=2.3\"," ""
  '';

  checkInputs = [ sympy pexpect symengine pytest ];
  propagatedBuildInputs = [
    pytools
    six
  ];

  # too many tests fail
  doCheck = false;
  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "A package for symbolic computation";
    homepage = "https://mathema.tician.de/software/pymbolic";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
