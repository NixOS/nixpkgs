{ fetchurl, stdenv, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-2.6.0";

  src = fetchurl {
    url = "http://protobuf.googlecode.com/svn-history/r579/rc/protobuf-2.6.0.tar.bz2";
    sha256 = "0krfkxc85vfznqwbh59qlhp7ld81al9ss35av0gfbg74i0rvjids";
  };

  buildInputs = [ zlib ];

  doCheck = true;

  meta = {
    description = "Protocol Buffers - Google's data interchange format";

    longDescription =
      '' Protocol Buffers are a way of encoding structured data in an
         efficient yet extensible format.  Google uses Protocol Buffers for
         almost all of its internal RPC protocols and file formats.
      '';

    license = "mBSD";

    homepage = http://code.google.com/p/protobuf/;
  };
}
