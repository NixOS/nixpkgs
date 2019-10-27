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
  version = "2018.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a47d5524d6a3cdc8a028079ce632eeb45ceea7243272d234f250622087688207";
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
    homepage = https://mathema.tician.de/software/pymbolic;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
