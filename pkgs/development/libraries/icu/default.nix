{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "icu4c-3.6";
  src = fetchurl {
    url = ftp://ftp.software.ibm.com/software/globalization/icu/3.6/icu4c-3_6-src.tgz;
    sha256 = "0hdh8sbpmabijprdpn7rmsqilw97f3paxxsxa4hd61k2kpbfhdai";
  };
  postUnpack="
    sourceRoot=\${sourceRoot}/source
    echo Source root reset to \${sourceRoot}
  ";
  configureFlags="--disable-debug";
}
