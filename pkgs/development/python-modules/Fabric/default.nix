{ lib, buildPythonPackage, fetchPypi
, cryptography
, invoke
, mock
, paramiko
, pytest
, pytest-relaxed
}:

buildPythonPackage rec {
  pname = "fabric";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19nzdibjfndzcwvby20p59igqwyzw7skrb45v2mxqsjma5yjv114";
  };

  propagatedBuildInputs = [ invoke paramiko cryptography ];
  checkInputs = [ pytest mock pytest-relaxed ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "Pythonic remote execution";
    homepage    = "https://www.fabfile.org/";
    license     = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
