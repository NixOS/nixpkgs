{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "requests-wsgi-adapter";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WncJ6Qq/SdGB9sMqo3eUU39yXeD23UI2K8jIyQgSyHg=";
  };

  propagatedBuildInputs = [ requests ];

  # tests are not contained in pypi-release
  doCheck = false;

  meta = with lib; {
    description = "WSGI Transport Adapter for Requests";
    homepage = "https://github.com/seanbrant/requests-wsgi-adapter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ betaboon ];
  };
}
