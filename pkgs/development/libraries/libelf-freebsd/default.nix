{ lib, fetchsvn, stdenv, gnum4, tet }:

stdenv.mkDerivation (rec {
  version = "3258";
  pname = "libelf-freebsd";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/elftoolchain/code/trunk";
    rev = (lib.strings.toInt version);
    name = "elftoolchain-${version}";
    sha256 = "1rcmddjanlsik0b055x8k914r9rxs8yjsvslia2nh1bhzf1lxmqz";
  };

  buildInputs = [ gnum4 tet ];

  buildPhase = ''
    PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:$PATH # use BSD install(1) instead of coreutils and make(1) instead of GNU Make
    cp -vr ${tet} test/tet/tet3.8
    chmod -R a+w test/tet/tet3.8
    make libelf
  '';

  installPhase = ''
    cp -vr libelf $out
    cp -vr common/. $out/
  '';

  meta = {
    description = "Essential compilation tools and libraries for building and analyzing ELF based program images";

    homepage = "https://sourceforge.net/p/elftoolchain/wiki/Home/";

    license = lib.licenses.bsd2;

    platforms = lib.platforms.freebsd;
    maintainers = [ ];
  };
})
