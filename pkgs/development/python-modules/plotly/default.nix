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
  version = "2.2.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dadd2263f1c0449b248fd3742a077d9594935921a9597529be76d6a841237ab0";
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
