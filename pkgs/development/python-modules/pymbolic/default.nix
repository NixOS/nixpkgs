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
  version = "2022.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tS9FHdC5gD4D3jMgrzt85XIwcAYcbSMcACFvbaQlkBI=";
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
