# Build Open Dylan from source using the binary builds to bootstrap.
{stdenv, fetchgit, boehmgc, mps, gnused, opendylan-bootstrap, autoconf, automake, perl, makeWrapper, gcc }:

stdenv.mkDerivation {
  name = "opendylan-2016.1pre";

  src = fetchgit {
    url = https://github.com/dylan-lang/opendylan;
    rev = "cd9a8395586d33cc43a8611c1dc0513e69ee82dd";
    sha256 = "00r1dm7mjy5p4hfm13vc4b6qryap40zinia3y15rhvalc3i2np4b";
    fetchSubmodules = true;
  };

  buildInputs = (if stdenv.system == "i686-linux" then [ mps ] else [ boehmgc ]) ++ [
    opendylan-bootstrap boehmgc gnused autoconf automake perl makeWrapper
  ];

  preConfigure = if stdenv.system == "i686-linux" then ''
    mkdir -p $TMPDIR/mps
    tar --strip-components=1 -xf ${mps.src} -C $TMPDIR/mps
    ./autogen.sh
  ''
  else ''
    ./autogen.sh
  '';

  configureFlags = [
    (if stdenv.system == "i686-linux" then "--with-mps=$(TMPDIR)/mps" else "--with-gc=${boehmgc.out}")
  ];
  buildPhase = "make 3-stage-bootstrap";

  postInstall = "wrapProgram $out/bin/dylan-compiler --suffix PATH : ${gcc}/bin";

  meta = {
    homepage = https://opendylan.org;
    description = "A multi-paradigm functional and object-oriented programming language";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
