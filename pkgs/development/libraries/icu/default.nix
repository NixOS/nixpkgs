{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "icu4c-3.6";
  
  src = fetchurl {
    url = ftp://ftp.software.ibm.com/software/globalization/icu/3.6/icu4c-3_6-src.tgz;
    sha256 = "0hdh8sbpmabijprdpn7rmsqilw97f3paxxsxa4hd61k2kpbfhdai";
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
}
