{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Gvqk1ZNHGjuamHXMm37fLfik8xdnnqZYqPj6JVU5zpA=";
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
