{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "pyechonest";
  version = "8.0.2";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "496265f4b7d33483ec153b9e1b8333fe959b115f7e781510089c8313b7d86560";
  };

  meta = with stdenv.lib; {
    description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
    homepage = https://github.com/echonest/pyechonest;
  };
}
