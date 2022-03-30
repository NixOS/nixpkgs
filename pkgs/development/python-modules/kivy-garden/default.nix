{ lib
, buildPythonPackage, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "kivy-garden";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K4N3N46HUB1dJx8z2U8ORMCJiEVyxk+JydYJsfhqJ0g=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "garden" ];

  # There are no tests in the Pypi archive and building from source is not
  # easily feasible because the build is done using buildozer and multiple
  # repositories.
  doCheck = false;

  meta = with lib; {
    description = "The kivy garden installation script, split into its own package for convenient use in buildozer.";
    homepage = "https://pypi.python.org/pypi/kivy-garden";
    license = licenses.mit;
    maintainers = with maintainers; [ risson ];
  };
}
