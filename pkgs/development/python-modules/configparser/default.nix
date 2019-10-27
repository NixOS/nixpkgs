{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "configparser";
  version = "3.7.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9395033080372df999e206387b295946928e2886dd64c5fee7db7ff36c6c6f8e";
  };

  # No tests available
  doCheck = false;

  preConfigure = ''
    export LC_ALL=${if stdenv.isDarwin then "en_US" else "C"}.UTF-8
  '';

  meta = with stdenv.lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+.";
    license = licenses.mit;
    homepage = https://github.com/jaraco/configparser;
  };
}
