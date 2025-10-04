{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
  pytest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "click-plugins";
  version = "1.1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "click_plugins";
    inherit version;
    sha256 = "sha256-1685hKmdJDwTGqGoKDMedjD0qIqXQf0FySeyBLz5ImE=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "Extension module for click to enable registering CLI commands";
    homepage = "https://github.com/click-contrib/click-plugins";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
