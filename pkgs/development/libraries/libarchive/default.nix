{fetchurl, stdenv, zlib, bzip2, e2fsprogs, sharutils}:

stdenv.mkDerivation rec {
  name = "libarchive-2.4.12";

  src = fetchurl {
    url = "${meta.homepage}/src/${name}.tar.gz";
    sha256 = "133kxx1wfangrhy6rcpqlqib7i45qxj8pcp3i9n574cwfx41swy4";
  };

  propagatedBuildInputs = [zlib bzip2 e2fsprogs];
  
  buildInputs = [sharutils];
  
  meta = {
    description = "A library for reading and writing streaming archives";
    homepage = http://people.freebsd.org/~kientzle/libarchive;
  };
}
