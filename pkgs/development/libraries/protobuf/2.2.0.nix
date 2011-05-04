{ fetchurl, stdenv, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-2.2.0";

  src = fetchurl {
    url = "http://protobuf.googlecode.com/files/${name}.tar.bz2";
    sha256 = "0jvj7i0fifl4fqjf84f67chb9b6q2z1jqkfc1zic9fz035mzn7bk";
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
