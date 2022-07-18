{ buildPythonPackage
, fetchPypi
, fetchurl
, lib
, nixosTests
, python
, pythonOlder

# pythonPackages
, dnspython
, expiringdict
, publicsuffix2
, xmltodict
, geoip2
, urllib3
, requests
, imapclient
, dateparser
, mailsuite
, elasticsearch
, elasticsearch-dsl
, kafka-python
, tqdm
, lxml
, boto3
, msgraph-core
, azure-identity
, google-api-core
, google-api-python-client
, google-auth
, google-auth-httplib2
, google-auth-oauthlib
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "8.2.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb82328dffb4a62ddaefbcc22efd5a2694350504a56d41ba1e161f2d998dcbff";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "elasticsearch<7.14.0" "elasticsearch"
  '';

  propagatedBuildInputs = [
    dnspython
    expiringdict
    publicsuffix2
    xmltodict
    geoip2
    urllib3
    requests
    imapclient
    dateparser
    mailsuite
    elasticsearch
    elasticsearch-dsl
    kafka-python
    tqdm
    lxml
    boto3
    msgraph-core
    azure-identity
    google-api-core
    google-api-python-client
    google-auth
    google-auth-httplib2
    google-auth-oauthlib
  ];

  # no tests on PyPI, no tags on GitHub
  doCheck = false;

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
