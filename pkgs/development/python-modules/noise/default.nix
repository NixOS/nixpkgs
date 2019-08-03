{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "noise";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rcv40dcshqpchwkdlhsv3n68h9swm9fh4d1cgzr2hsp6rs7k8jp";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/caseman/noise;
    description = "Native-code and shader implementations of Perlin noise";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
