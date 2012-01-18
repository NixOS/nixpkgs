{fetchurl, stdenv, acl, openssl, libxml2, attr, zlib, bzip2, e2fsprogs
, sharutils}:

stdenv.mkDerivation rec {
  name = "libarchive-2.8.3";

  src = fetchurl {
    url = "http://libarchive.googlecode.com/files/${name}.tar.gz";
    sha256 = "16095d15334b3c8dbb02db5af3d415f12c1c3bdd4eb43af7bbc36ab7572c0b7a";
  };

  propagatedBuildInputs = [libxml2 zlib bzip2 openssl] ++
    (if stdenv.isLinux then [e2fsprogs attr acl] else []);

  buildInputs = [sharutils];

  meta = {
    description = "A library for reading and writing streaming archives";
    homepage = http://people.freebsd.org/~kientzle/libarchive;
  };
}
