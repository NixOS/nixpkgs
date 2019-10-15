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
  version = "5.7.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a6q7jcqwcqf8cv76lzldf90hnj2x8gha754x515dq10zsi9sjms";
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

  postPatch = ''
    sed -i s/pyyaml==3.12/pyyaml==${pyyaml.version}/ setup.cfg setup.py
  '';

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

    # https://github.com/elastic/curator/pull/1280
    broken = versionAtLeast click.version "7.0";
  };
}
