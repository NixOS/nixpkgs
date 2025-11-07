{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,

  # build-system
  hatchling,

  # dependencies
  azure-identity,
  azure-monitor-ingestion,
  boto3,
  dateparser,
  dnspython,
  elastic-transport,
  elasticsearch-dsl,
  elasticsearch,
  expiringdict,
  geoip2,
  google-api-core,
  google-api-python-client,
  google-auth-httplib2,
  google-auth-oauthlib,
  google-auth,
  imapclient,
  kafka-python-ng,
  lxml,
  mailsuite,
  msgraph-core,
  nixosTests,
  opensearch-py,
  publicsuffixlist,
  pygelf,
  requests,
  tqdm,
  xmltodict,

  # test
  unittestCheckHook,
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "6.18.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "parsedmarc";
    tag = version;
    hash = "sha256-AjRYd3uN76Zl7IEXqFK+qssAvuS+TbT+mZL+pPlxDwc=";
  };

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "elasticsearch"
    "elasticsearch-dsl"
  ];

  dependencies = [
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
    kafka-python-ng
    lxml
    mailsuite
    msgraph-core
    opensearch-py
    publicsuffixlist
    pygelf
    requests
    tqdm
    xmltodict
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [ "parsedmarc" ];

  passthru = {
    inherit dashboard;
    tests = nixosTests.parsedmarc;
  };

  meta = {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    changelog = "https://github.com/domainaware/parsedmarc/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talyz ];
    mainProgram = "parsedmarc";
    # https://github.com/domainaware/parsedmarc/issues/464
    broken = lib.versionAtLeast msgraph-core.version "1.0.0";
  };
}
