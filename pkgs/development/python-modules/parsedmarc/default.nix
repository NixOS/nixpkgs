{
  lib,
  azure-identity,
  azure-monitor-ingestion,
  boto3,
  buildPythonPackage,
  dateparser,
  dnspython,
  elastic-transport,
  elasticsearch,
  elasticsearch-dsl,
  expiringdict,
  fetchPypi,
  fetchurl,
  geoip2,
  google-api-core,
  google-api-python-client,
  google-auth,
  google-auth-httplib2,
  google-auth-oauthlib,
  hatchling,
  imapclient,
  kafka-python,
  lxml,
  mailsuite,
  msgraph-core,
  nixosTests,
  opensearch-py,
  publicsuffixlist,
  pythonOlder,
  requests,
  tqdm,
  xmltodict,
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "8.11.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OBxiaXB8NKNMviRI19rYYJxpnfnaEL3zSPmYB4urIug=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonRelaxDeps = [
    "elasticsearch"
    "elasticsearch-dsl"
  ];

  propagatedBuildInputs = [
    azure-identity
    azure-monitor-ingestion
    boto3
    dateparser
    dnspython
    elastic-transport
    elasticsearch
    elasticsearch-dsl
    expiringdict
    geoip2
    google-api-core
    google-api-python-client
    google-auth
    google-auth-httplib2
    google-auth-oauthlib
    imapclient
    kafka-python
    lxml
    mailsuite
    msgraph-core
    publicsuffixlist
    requests
    tqdm
    xmltodict
    opensearch-py
  ];

  # no tests on PyPI, no tags on GitHub
  # https://github.com/domainaware/parsedmarc/issues/426
  doCheck = false;

  pythonImportsCheck = [ "parsedmarc" ];

  passthru = {
    inherit dashboard;
    tests = nixosTests.parsedmarc;
  };

  meta = with lib; {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    changelog = "https://github.com/domainaware/parsedmarc/blob/master/CHANGELOG.md#${
      lib.replaceStrings [ "." ] [ "" ] version
    }";
    license = licenses.asl20;
    maintainers = with maintainers; [ talyz ];
    mainProgram = "parsedmarc";
    # https://github.com/domainaware/parsedmarc/issues/464
    broken = lib.versionAtLeast msgraph-core.version "1.0.0";
  };
}
