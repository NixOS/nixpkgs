{ buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "143887ac647ad30819f289f5a4ca13b77e56df27b686b84c34669447f7591280";
  };

  propagatedBuildInputs = [ chardet six ];
}
