{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "easywebdav";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-scziC+Fg81TusT7bQdr+mdjqsUnArpuzNfehRRj1X4U=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ requests ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "easywebdav" ];

  meta = {
    description = "Straight-forward WebDAV client, implemented using Requests";
    homepage = "https://github.com/amnong/easywebdav";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ xyven1 ];
  };
}
