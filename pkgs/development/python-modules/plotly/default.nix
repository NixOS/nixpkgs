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
  version = "2.4.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e7ee039231fec52b0b38d45e7470f70b117f6527b08cc922d74992f4d082858";
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
