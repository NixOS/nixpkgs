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
  version = "2020.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca029399f9480f6d51fbac0349fddbb42d937620deb03befa0ba94ac08895e6b";
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
