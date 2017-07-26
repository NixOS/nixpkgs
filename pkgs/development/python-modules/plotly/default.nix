{ lib
, buildPythonPackage
, fetchPypi
, decorator
, nbformat
, pytz
, requests
, six
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "2.0.10";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c013a01bb11c4c269c38a7086ffb92d6a2827922c49706131842498a49b3b81";
  };

  propagatedBuildInputs = [
    decorator
    nbformat
    pytz
    requests
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Python plotting library for collaborative, interactive, publication-quality graphs";
    homepage = https://plot.ly/python/;
    license = with lib.licenses; [ mit ];
  };
}
