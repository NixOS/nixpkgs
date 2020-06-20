{ stdenv, fetchFromGitHub, nasm }:

stdenv.mkDerivation rec {
  pname = "openh264";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "cisco";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ffav46pz3sbj92nipd62z03fibyqgclfq9w8lgr80s6za6zdk5s";
  };

  nativeBuildInputs = [ nasm ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "A codec library which supports H.264 encoding and decoding";
    homepage = "https://www.openh264.org";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
