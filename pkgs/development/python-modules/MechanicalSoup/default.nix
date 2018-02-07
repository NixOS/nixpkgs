{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six, lxml
, pytestrunner, requests-mock, pytestcov, pytest
}:


buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "MechanicalSoup";
  version = "0.9.0.post4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce8f822afbc9bef1499be417e8d5deecd0cd32606420165700e89477955f03ab";
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
