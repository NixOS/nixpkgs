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
  version = "0.7.14";
  
  src = fetchPypi {
    inherit pname version;
    sha256 = "0a6ce8b5f247fbfe5a53829c2f22391161e88646742283f861bce32bfe1626f1";
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

