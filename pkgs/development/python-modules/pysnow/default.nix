{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pythonAtLeast
, brotli
, ijson
, nose
, requests_oauthlib 
, python_magic
, pytz
}:

buildPythonPackage rec {
  pname = "pysnow";
  version = "0.7.16";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "5df61091470e48b5b3a6ea75637f69d3aacae20041487ea457a9a0e3093fba8c";
  };

  propagatedBuildInputs = [
    brotli
    ijson 
    python_magic 
    pytz 
    requests_oauthlib
  ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests --cover-package=pysnow --with-coverage --cover-erase
  '';

  meta = with lib; {
    description = "ServiceNow HTTP client library written in Python";
    homepage = "https://github.com/rbw/pysnow";
    license = licenses.mit;
    maintainers = [ maintainers.almac ];  
  };

}

