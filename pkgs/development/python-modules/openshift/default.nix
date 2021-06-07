{
  lib
  , buildPythonPackage
  , fetchPypi
  , jinja2
  , kubernetes
  , ruamel-yaml
  , six
  , python-string-utils
}:

buildPythonPackage rec {
  pname = "openshift";
  version = "0.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aggRnD4goiZJPp4cngp8AIrJC/V46378cwUSfq8Xml4=";
  };

  propagatedBuildInputs = [
    jinja2
    kubernetes
    python-string-utils
    ruamel-yaml
    six
  ];

  # tries to connect to the network
  doCheck = false;
  pythonImportsCheck = ["openshift"];

  meta = with lib; {
    description = "Python client for the OpenShift API";
    homepage = "https://github.com/openshift/openshift-restclient-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
