# Build Open Dylan from source using the binary builds to bootstrap.
{lib, stdenv, fetchFromGitHub, boehmgc, mps, gnused, opendylan-bootstrap, autoconf, automake, perl, makeWrapper, gcc }:

stdenv.mkDerivation {
  pname = "opendylan";
  version = "2016.1pre";

  src = fetchFromGitHub {
    owner = "dylan-lang";
    repo = "opendylan";
    rev = "cd9a8395586d33cc43a8611c1dc0513e69ee82dd";
    sha256 = "sha256-i1wr4mBUbZhL8ENFGz8gV/mMzSJsj1AdJLd4WU9tIQM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ makeWrapper autoconf automake ];
  buildInputs = (if stdenv.hostPlatform.system == "i686-linux" then [ mps ] else [ boehmgc ]) ++ [
    opendylan-bootstrap boehmgc perl
  ];

  preConfigure = if stdenv.hostPlatform.system == "i686-linux" then ''
    mkdir -p $TMPDIR/mps
    tar --strip-components=1 -xf ${mps.src} -C $TMPDIR/mps
    ./autogen.sh
  ''
  else ''
    ./autogen.sh
  '';

  configureFlags = [
    (if stdenv.hostPlatform.system == "i686-linux" then "--with-mps=$(TMPDIR)/mps" else "--with-gc=${boehmgc.out}")
  ];
  buildPhase = "make 3-stage-bootstrap";

  postInstall = "wrapProgram $out/bin/dylan-compiler --suffix PATH : ${gcc}/bin";

  meta = {
    homepage = "https://opendylan.org";
    description = "A multi-paradigm functional and object-oriented programming language";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    broken = true; # last successful build 2020-12-11
  };
}
