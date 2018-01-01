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
  version = "2.0.16";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88db14a8a42bc92d0d5d7e411659e5497376c572f40e8e681280199f0d41a540";
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
