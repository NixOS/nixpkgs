{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
}:

buildPythonPackage rec {
  pname = "Protego";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G5lgVhekLOB7BJ4LnW3D7l77mSTyb9EV6q+8j5o3Rw4=";
  };
  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "A pure-Python robots.txt parser with support for modern conventions";
    homepage = "https://github.com/scrapy/protego";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
  };
}
