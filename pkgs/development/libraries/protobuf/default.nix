{ stdenv, fetchFromGitHub, autoreconfHook, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-${version}";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "protobuf";
    rev = "v${version}";
    sha256 = "020a59x9kbrbhh207j62gw55pj7p5rvz01i6ml6xhpcghp7l50b4";
  };

  buildInputs = [ autoreconfHook zlib ];

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/protobuf/;
    description = "Protocol Buffers - Google's data interchange format";
    longDescription =
      '' Protocol Buffers are a way of encoding structured data in an
         efficient yet extensible format.  Google uses Protocol Buffers for
         almost all of its internal RPC protocols and file formats.
      '';
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
