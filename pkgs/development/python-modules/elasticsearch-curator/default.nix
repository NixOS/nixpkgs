{ stdenv
, buildPythonPackage
, fetchPypi
, boto3
, click
, certifi
, requests-aws4auth
, voluptuous
, pyyaml
, elasticsearch
, nosexcover
, coverage
, nose
, mock
, funcsigs
} :

buildPythonPackage rec {
  pname   = "elasticsearch-curator";
  version = "5.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e75abeb7f7be939b1c64c071898760dc10ab5f08307c253fc074abf8a41a76f0";
  };

  # The test hangs so we disable it.
  doCheck = false;

  propagatedBuildInputs = [
    click
    certifi
    requests-aws4auth
    voluptuous
    pyyaml
    elasticsearch
    boto3
  ];

  checkInputs = [
    nosexcover
    coverage
    nose
    mock
    funcsigs
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/elastic/curator;
    description = "Curate, or manage, your Elasticsearch indices and snapshots";
    license = licenses.asl20;
    longDescription = ''
      Elasticsearch Curator helps you curate, or manage, your Elasticsearch
      indices and snapshots by:

      * Obtaining the full list of indices (or snapshots) from the cluster, as the
        actionable list

      * Iterate through a list of user-defined filters to progressively remove
        indices (or snapshots) from this actionable list as needed.

      * Perform various actions on the items which remain in the actionable list.
    '';
    maintainers = with maintainers; [ basvandijk ];
  };
}
