{ lib
, buildPythonPackage, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "kivy-garden";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wkcpr2zc1q5jb0bi7v2dgc0vs5h1y7j42mviyh764j2i0kz8mn2";
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
