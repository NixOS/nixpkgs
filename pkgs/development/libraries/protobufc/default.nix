{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, protobuf, zlib }:

stdenv.mkDerivation rec {
  name = "protobuf-c-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "protobuf-c";
    repo = "protobuf-c";
    rev = "v${version}";
    sha256 = "1harabw7qdgcmh098664xkcv8bkyach6i35sisc40yhvagr3fzsz";
  };

  buildInputs = [ autoreconfHook pkgconfig protobuf zlib ];

  meta = with stdenv.lib; {
    homepage = http://github.com/protobuf-c/protobuf-c/;
    description = "C bindings for Google's Protocol Buffers";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
