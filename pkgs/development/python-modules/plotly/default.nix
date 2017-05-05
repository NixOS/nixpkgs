{ lib
, buildPythonPackage
, fetchPypi
, decorator
, nbformat
, pytz
, requests2
, six
}:

buildPythonPackage rec {
  pname = "plotly";
  version = "2.0.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zbwx771w6425w4g6l9fhq4x1854fdnni6xq9xhvs8xqgxkrljm5";
  };

  propagatedBuildInputs = [
    decorator
    nbformat
    pytz
    requests2
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
