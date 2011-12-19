{ fetchurl, stdenv, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-2.4.1";

  src = fetchurl {
    url = "http://protobuf.googlecode.com/files/${name}.tar.bz2";
    sha256 = "1gxhfhk37jyjq1z4y3d4bz4i1fk2an5ydhk5kjzlp0rhfcs5516g";
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
