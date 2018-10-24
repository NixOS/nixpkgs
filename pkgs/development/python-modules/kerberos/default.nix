{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "kerberos";
  version = "1.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11q9jhzdl88jh8jgn7cycq034m36g2ncxds7mr3vqkngpcirkx6n";
  };

  buildInputs = [ pkgs.kerberos ];

  meta = with stdenv.lib; {
    description = "Kerberos high-level interface";
    homepage = https://pypi.python.org/pypi/kerberos;
    license = licenses.asl20;
  };

}
