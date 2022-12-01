{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p0gyhfqq6gssf3prsy0pcfq5w0wx2w3pcjqbwx3imvc92ls4xwm";
  };

  # no tests in pypi package
  doCheck = false;

  pythonImportsCheck = [ "backports.datetime_fromisoformat" ];

  meta = with lib; {
    description = "Backport of Python 3.7's datetime.fromisoformat";
    homepage = "https://github.com/movermeyer/backports.datetime_fromisoformat";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
