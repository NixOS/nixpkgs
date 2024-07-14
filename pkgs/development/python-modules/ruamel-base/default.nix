{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ruamel-base";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "ruamel.base";
    inherit version;
    hash = "sha256-wEEzOg8PAM1lk+s2qoOrsannVE6DunpCqnrHR2zuXPM=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "ruamel.base" ];

  pythonNamespaces = [ "ruamel" ];

  meta = with lib; {
    description = "Common routines for ruamel packages";
    homepage = "https://sourceforge.net/projects/ruamel-base/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
