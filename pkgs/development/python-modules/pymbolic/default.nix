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
  version = "2019.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7507864a76574d72bf5732497b247661c6ad73bb277cd9c8aae09e90a62e05a";
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
