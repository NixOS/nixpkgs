{ buildPythonPackage
, fetchPypi
, fetchurl
, pythonOlder
, lib
, nixosTests

# pythonPackages
, tqdm
, dnspython
, expiringdict
, urllib3
, requests
, publicsuffix2
, xmltodict
, geoip2
, imapclient
, dateparser
, elasticsearch-dsl
, kafka-python
, mailsuite
, lxml
, boto3
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "7.0.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mi4hx410y7ikpfy1582lm252si0c3yryj0idqgqbx417fm21jjc";
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
    imapclient
    dateparser
    elasticsearch-dsl
    kafka-python
    mailsuite
    lxml
    boto3
  ];

  pythonImportsCheck = [ "parsedmarc" ];

  passthru = {
    inherit dashboard;
    tests = nixosTests.parsedmarc;
  };

  meta = {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    maintainers = with lib.maintainers; [ talyz ];
    license = lib.licenses.asl20;
  };
}
