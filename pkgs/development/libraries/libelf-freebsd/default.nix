{ fetchsvn, stdenv, gnum4, tet }:

stdenv.mkDerivation (rec {
  version = "3258";
  name = "libelf-freebsd-${version}";

  src = fetchsvn {
    url = svn://svn.code.sf.net/p/elftoolchain/code/trunk;
    rev = (stdenv.lib.strings.toInt version);
    name = "elftoolchain-${version}";
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

    homepage = https://sourceforge.net/p/elftoolchain/wiki/Home/;

    license = stdenv.lib.licenses.bsd2;

    platforms = stdenv.lib.platforms.freebsd;
    maintainers = [ ];
  };
})
