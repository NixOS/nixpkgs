{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "casttube";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VNKvjHlJqpxduH+xHvCkeKXT56xtLSrI3RcR46UW/II=";
  };

  propagatedBuildInputs = [ requests ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Interact with the Youtube Chromecast api";
    homepage = "https://github.com/ur1katz/casttube";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
