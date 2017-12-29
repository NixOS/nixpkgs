{ fetchPypi, buildPythonPackage, lib
, requests, beautifulsoup4, six
, pytestrunner, requests-mock, pytestcov, pytest
}:


buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "MechanicalSoup";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38a6ca35428196be94f87f8f036ee4a88b1418d1f77e5634ad92acfaa22c28da";
  };

  checkInputs = [ pytest pytestrunner requests-mock pytestcov ];

  propagatedBuildInputs = [ requests beautifulsoup4 six ];

  # Requires network
  doCheck = false;

  postPatch = ''
    # Is in setup_requires but not used in setup.py...
    substituteInPlace setup.py --replace "'pytest-runner'," ""
  '';

  meta = with lib; {
    description = "A Python library for automating interaction with websites";
    homepage = https://github.com/hickford/MechanicalSoup;
    license = licenses.mit;
    maintainers = [ maintainers.jgillich ];
  };
}
