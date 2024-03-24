{ pythonPackages }:
let
  packages = pythonPackages.overrideScope (final: prev: {
    elasticsearch = prev.elasticsearch.overridePythonAttrs (oldAttrs: rec {
      version = "7.13.1";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "d6bcca0b2e5665d08e6fe6fadc2d4d321affd76ce483603078fc9d3ccd2bc0f9";
      };
    });
    elasticsearch-dsl = prev.elasticsearch-dsl.overridePythonAttrs (oldAttrs: rec {
      version = "7.4.0";
      src = oldAttrs.src.override {
        inherit version;
        sha256 = "c4a7b93882918a413b63bed54018a1685d7410ffd8facbc860ee7fd57f214a6d";
      };
    });
  });
in
packages.callPackage (

{ lib
, azure-identity
, azure-monitor-ingestion
, boto3
, buildPythonPackage
, dateparser
, dnspython
, elastic-transport
, elasticsearch
, elasticsearch-dsl
, expiringdict
, fetchPypi
, fetchurl
, geoip2
, google-api-core
, google-api-python-client
, google-auth
, google-auth-httplib2
, google-auth-oauthlib
, hatchling
, imapclient
, kafka-python
, lxml
, mailsuite
, msgraph-core
, nixosTests
, publicsuffixlist
, pythonOlder
, requests
, tqdm
, urllib3
, xmltodict
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "8.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tK/cxOw50awcDAGRDTQ+Nxb9aJl2+zLZHuJq88xNmXM=";
  };

  nativeBuildInputs = [
    hatchling
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
    urllib3
    xmltodict
  ];

  # no tests on PyPI, no tags on GitHub
  # https://github.com/domainaware/parsedmarc/issues/426
  doCheck = false;

  pythonImportsCheck = [
    "parsedmarc"
  ];

  passthru = {
    inherit dashboard;
    tests = nixosTests.parsedmarc;
  };

  meta = with lib; {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    changelog = "https://github.com/domainaware/parsedmarc/blob/master/CHANGELOG.md#${lib.replaceStrings [ "." ] [ "" ] version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ talyz ];
    mainProgram = "parsedmarc";
  };
}

) {}
