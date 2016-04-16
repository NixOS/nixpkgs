# Build Open Dylan from source using the binary builds to bootstrap.
{stdenv, fetchgit, patchelf, boehmgc, mps, gnused, opendylan-bootstrap, autoconf, automake, perl, makeWrapper, gcc }:

stdenv.mkDerivation {
  name = "opendylan-2013.2";

  src = fetchgit {
    url = https://github.com/dylan-lang/opendylan;
    rev = "ce9b14dab6cb9ffedc69fae8c6df524c0c79abd3";
    sha256 = "cec80980b838ac2581dfb6282e25d208e720d475256b75e24b23dbd30b09d21f";
    fetchSubmodules = true;
  };

  buildInputs = (if stdenv.system == "i686-linux" then [ mps ] else [ boehmgc ]) ++ [
    opendylan-bootstrap boehmgc gnused autoconf automake perl makeWrapper
  ] ;

  preConfigure = if stdenv.system == "i686-linux" then ''
    mkdir -p $TMPDIR/mps
    tar --strip-components=1 -xf ${mps.src} -C $TMPDIR/mps
    ./autogen.sh
  ''
  else ''
    ./autogen.sh
  '';

  configureFlags = if stdenv.system == "i686-linux" then "--with-mps=$(TMPDIR)/mps" else "--with-gc=${boehmgc.dev}";
  buildPhase = "make 3-stage-bootstrap";

  postInstall = "wrapProgram $out/bin/dylan-compiler --suffix PATH : ${gcc}/bin";

  meta = {
    homepage = http://opendylan.org;
    description = "A multi-paradigm functional and object-oriented programming language";
    license = stdenv.lib.licenses.mit;
  };
}
