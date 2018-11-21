{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.10.6";
  pname = "netifaces";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q7bi5k2r955rlcpspx4salvkkpk28jky67fjbpz2dkdycisak8c";
  };

  meta = with stdenv.lib; {
    homepage = https://alastairs-place.net/projects/netifaces/;
    description = "Portable access to network interfaces from Python";
    license = licenses.mit;
  };

}
