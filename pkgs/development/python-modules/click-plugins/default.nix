{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  pytest,
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.1.1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1685hKmdJDwTGqGoKDMedjD0qIqXQf0FySeyBLz5ImE=";
  };

  propagatedBuildInputs = [ click ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Extension module for click to enable registering CLI commands";
    homepage = "https://github.com/click-contrib/click-plugins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
