{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "dns-messages";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-00gjYwEUeizid/kXxGV2WjBzO/PCpDjV2hMmYUdjPd4=";
  };

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "dns_messages" ];

  meta = {
    description = "A Python3 library for parsing and generating DNS messages";
    homepage = "https://github.com/wahlflo/dns-messages";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.symphorien ];
  };
}
