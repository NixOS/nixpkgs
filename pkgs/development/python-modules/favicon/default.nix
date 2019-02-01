{ lib, buildPythonPackage, fetchPypi, requests, beautifulsoup4, pytest, requests-mock,
  pytestrunner }:

buildPythonPackage rec {
  pname = "favicon";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01jhb66nrqbf22z6ybpi8ndw6zifgysdmnh547027g96nz51669y";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [ pytest requests-mock ];
  propagatedBuildInputs = [ requests beautifulsoup4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Find a website's favicon";
    homepage = http://github.com/scottwernervt/favicon;
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
  };
}
