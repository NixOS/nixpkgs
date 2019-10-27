{ stdenv, buildPythonPackage, fetchPypi, watchman }:

buildPythonPackage rec {
  pname = "pywatchman";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yf2gm20wc3djpb5larxii3l55xxby0il2ns3q0v1byyfnr7w16h";
  };

  postPatch = ''
    substituteInPlace pywatchman/__init__.py \
      --replace "'watchman'" "'${watchman}/bin/watchman'"
  '';

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Watchman client for Python";
    homepage = https://facebook.github.io/watchman/;
    license = licenses.bsd3;
  };

}
