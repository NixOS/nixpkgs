{ buildPythonPackage, fetchPypi, lib, arrow }:

buildPythonPackage rec {
  pname = "python-datemath";
  version = "1.4.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0v2cdsb9wixbhnlkmhb0p24xrf3h2phjwm2dcws4b5f9pd72hqd6";
  };

  propagatedBuildInputs = [ arrow ];

  meta = with lib; {
    description = "A python module to emulate the date math used in SOLR and Elasticsearch";
    license = licenses.mit;
    homepage = https://github.com/nickmaccarthy/python-datemath;
    maintainers = with maintainers; [ mredaelli ];
  };
}
