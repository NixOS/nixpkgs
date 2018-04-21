{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six, lxml
, pytestrunner, requests-mock, pytestcov, pytest
}:

buildPythonPackage rec {
  pname = "MechanicalSoup";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22423efd025c3eedb06f41d3ff1127174a59f40dc560e82dce143956976195bf";
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
    homepage = https://github.com/hickford/MechanicalSoup;
    license = licenses.mit;
    maintainers = [ maintainers.jgillich ];
  };
}
