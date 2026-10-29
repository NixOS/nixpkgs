{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-wsgi-adapter";
  version = "0.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-WncJ6Qq/SdGB9sMqo3eUU39yXeD23UI2K8jIyQgSyHg=";
  };

  propagatedBuildInputs = [ requests ];

  # tests are not contained in pypi-release
  doCheck = false;

  meta = {
    description = "WSGI Transport Adapter for Requests";
    homepage = "https://github.com/seanbrant/requests-wsgi-adapter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ betaboon ];
  };
})
