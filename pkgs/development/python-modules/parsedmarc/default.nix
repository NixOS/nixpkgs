{ buildPythonPackage
, fetchPypi
, fetchurl
, isPy3k
, lib

# pythonPackages
, tqdm
, dnspython
, expiringdict
, urllib3
, requests
, publicsuffix2
, xmltodict
, geoip2
, IMAPClient
, dateparser
, elasticsearch-dsl
, kafka-python
, mailsuite
, lxml
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "6.12.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0prfd76rv4a8rbfk755lzmpdbq47dhmc14i3aj4alhmpx0c0kaqz";
  };

  propagatedBuildInputs = [
    tqdm
    dnspython
    expiringdict
    urllib3
    requests
    publicsuffix2
    xmltodict
    geoip2
    IMAPClient
    dateparser
    elasticsearch-dsl
    kafka-python
    mailsuite
    lxml
  ];

  passthru = {
    inherit dashboard;
  };

  meta = {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
