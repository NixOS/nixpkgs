{ stdenv, fetchpatch, fetchurl }:

stdenv.mkDerivation rec {
  name = "expat-2.2.3";

  src = fetchurl {
    url = "mirror://sourceforge/expat/${name}.tar.bz2";
    sha256 = "0pyfma0sv4vif17kfv7xh2l2hl6skgw266a9cwm00p7q0bxr065k";
  };

  outputs = [ "out" "dev" ]; # TODO: fix referrers
  outputBin = "dev";

  patches = [
    (fetchpatch {
      name = "fix-aarch-build.patch";
      url = "https://github.com/libexpat/libexpat/commit/d98d4399174fd6f71d70e7bd89993a0e7346753d.patch";
      sha256 = "0z89wb4mzyf7vvl6kbflk5w1z7yc39jwvs3mkznin5agj34x063w";
      stripLen = 1;
      excludes = [ "coverage.sh" ];
    })
  ];

  configureFlags = stdenv.lib.optional stdenv.isFreeBSD "--with-pic";

  outputMan = "dev"; # tiny page for a dev tool

  doCheck = true;

  preCheck = "patchShebangs ./run.sh";

  meta = with stdenv.lib; {
    homepage = http://www.libexpat.org/;
    description = "A stream-oriented XML parser library written in C";
    platforms = platforms.all;
    license = licenses.mit; # expat version
  };
}
