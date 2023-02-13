{ lib
, callPackage
, buildPythonPackage
, fetchPypi
, runCommand
, setuptools
}:

# Is required for properly testing mkdocs-macros
buildPythonPackage rec {
  pname = "mkdocs-macros-test";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:1w12skm8l0r2x6z1va996lvq6z1873d0xzql9n0aja0g0v6s7ay5";
  };

  pythonImportsCheck = [ "mkdocs_macros_test" ];

  meta = with lib; {
    homepage = "https://github.com/fralau/mkdocs-macros-test";
    description = "Implementation of a (model) pluglet for mkdocs-macros";
    license = licenses.mit;
    maintainers = with maintainers; [ tljuniper ];
  };
}
