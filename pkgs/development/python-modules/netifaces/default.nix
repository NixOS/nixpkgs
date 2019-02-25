{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.10.9";
  pname = "netifaces";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3";
  };

  meta = with stdenv.lib; {
    homepage = https://alastairs-place.net/projects/netifaces/;
    description = "Portable access to network interfaces from Python";
    license = licenses.mit;
  };

}
