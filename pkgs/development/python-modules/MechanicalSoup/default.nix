{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six, lxml
, pytestrunner, requests-mock, pytestcov, pytest
}:

buildPythonPackage rec {
  pname = "MechanicalSoup";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g976rk79apz6rc338zq3ml2yps8hb88nyw3a698d0brm4khd9ir";
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
