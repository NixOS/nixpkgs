{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six, lxml
, pytestrunner, requests-mock, pytestcov, pytest
}:

buildPythonPackage rec {
  pname = "MechanicalSoup";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0k59wwk75q7nz6i6gynvzhagy02ql0bv7py3qqcwgjw7607yq4i7";
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
