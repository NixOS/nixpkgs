{ stdenv
, buildPythonPackage
, fetchPypi
, pillow
}:

buildPythonPackage rec {
  pname = "pillowfight";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "913869b0563c5982bcf08cb1ea56fb0f87e3573d738e3e3692301bf45dba6252";
  };

  propagatedBuildInputs = [ pillow ];

  meta = with stdenv.lib; {
    description = "Pillow Fight";
    homepage = "https://github.com/beanbaginc/pillowfight";
    license = licenses.mit;
  };

}
