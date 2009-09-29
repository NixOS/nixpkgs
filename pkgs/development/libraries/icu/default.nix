{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "icu4c-4.2";
  
  src = fetchurl {
    url = http://download.icu-project.org/files/icu4c/4.2.1/icu4c-4_2_1-src.tgz;
    sha256 = "0qw050msb34wr522s7s83i6skxsc9i19p4rlvmf99pqk2hgf6kc1";
  };

  patchFlags = "-p0";

  patches = [
    (fetchurl {
      url = "http://sources.gentoo.org/viewcvs.py/*checkout*/gentoo-x86/dev-libs/icu/files/icu-3.8-setBreakType-public.diff?rev=1.1";
      sha256 = "09g39rzj3bdf2q9n47rzdlpcjyipip42swbjpb0gjzp439jv3wmk";
    })
  ];
  
  postUnpack = "
    sourceRoot=\${sourceRoot}/source
    echo Source root reset to \${sourceRoot}
  ";
  
  configureFlags = "--disable-debug";

  meta = {
    description = "Unicode and globalization support library";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
