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
  version = "2.0.15";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ecd16a11778674c63615a590e22f79307801eaf009b399bf7e46c486dec8f99";
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
