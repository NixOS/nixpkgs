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
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a38957684b17ad0e140a87226249bf26de7267db0c83a6d512b48be258052e1a";
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
