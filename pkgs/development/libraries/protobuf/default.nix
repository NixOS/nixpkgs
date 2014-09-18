{ fetchurl, stdenv, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-2.5.0";

  src = fetchurl {
    url = "http://protobuf.googlecode.com/files/${name}.tar.bz2";
    sha256 = "0xxn9gxhvsgzz2sgmihzf6pf75clr05mqj6218camwrwajpcbgqk";
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
