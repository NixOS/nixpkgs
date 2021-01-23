{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six, lxml
, pytestrunner, requests-mock, pytestcov, pytest
}:

buildPythonPackage rec {
  pname = "MechanicalSoup";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37d3b15c1957917d3ae171561e77f4dd4c08c35eb4500b8781f6e7e1bb6c4d07";
  };

  checkInputs = [ pytest pytestrunner requests-mock pytestcov ];

  propagatedBuildInputs = [ lxml requests beautifulsoup4 six ];

  # Requires network
  doCheck = false;

  postPatch = ''
    # Is in setup_requires but not used in setup.py...
    substituteInPlace setup.py --replace "'pytest-runner'" ""
  '';

  meta = with lib; {
    description = "A Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
    license = licenses.mit;
    maintainers = [ maintainers.jgillich ];
  };
}
