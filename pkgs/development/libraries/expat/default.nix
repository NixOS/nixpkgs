{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "expat-2.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "067cfhqwiswm4zynw7xaxl59mrrimaiyjhnn8byxma1i98pi1jfb";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-15903.patch";
      url = "https://sources.debian.org/data/main/e/expat/2.2.7-2/debian/patches/CVE-2019-15903_Deny_internal_entities_closing_the_doctype.patch";
      sha256 = "0lv4392ihpk71fgaf1fz03gandqkaqisal8xrzvcqnvnq4mnmwxp";
      stripLen = 1;
      excludes = [ "tests/runtests.c" "Changes" ];
    })
  ];

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true; # not cross;

  preCheck = ''
    patchShebangs ./run.sh
    patchShebangs ./test-driver-wrapper.sh
  '';

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
