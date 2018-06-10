{ stdenv
, buildPythonPackage
, fetchPypi
, click
, certifi
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
  version = "5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d2762fa55613855b0a04f22e1c6c2c5b53d60301b437205d0e2533e4185671a";
  };

  # The integration tests require a running elasticsearch cluster.
  postUnpackPhase = ''
    rm -r test/integration
  '';

  propagatedBuildInputs = [
    click
    certifi
    voluptuous
    pyyaml
    elasticsearch
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
