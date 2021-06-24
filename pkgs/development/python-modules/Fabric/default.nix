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

  # requires pytest_relaxed, which doesnt have official support for pytest>=5
  # https://github.com/bitprophet/pytest-relaxed/issues/12
  doCheck = false;
  checkPhase = ''
    pytest tests
  '';
  pythonImportsCheck = [ "fabric" ];

  meta = with lib; {
    description = "Pythonic remote execution";
    homepage    = "https://www.fabfile.org/";
    license     = licenses.bsd2;
    maintainers = [ maintainers.costrouc ];
  };
}
