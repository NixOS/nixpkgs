{ stdenv, fetchurl, pkgconfig
, openssl, tqtinterface, tqt3 }:

let baseName = "tqca-tls"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "09ra6qk27x1d2s8d0l71a59rwrp6xwhw4wwdsvm8z7f2dqz12ipz";
  };
  
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ openssl tde.tqtinterface ];

  patchPhase = ''
    sed -i -e "s|/usr/include/tqt|${tde.tqtinterface}/include/tqt|" ${baseName}/configure
    sed -i -e '/for p in/ s|/usr|/FAILURE|g' ${baseName}/configure
  '';

  preConfigure = ''
    cd ${baseName}
  '';

  dontAddPrefix = true;
  configureFlags = "--debug --qtdir=${tqt3} --with-openssl-inc=${openssl.dev}/include --with-openssl-lib=${openssl.out}/lib";

  installPhase = ''
    mkdir -p $out/plugins/crypto
    cp libtqca-tls.so $out/plugins/crypto
  '';

  meta = with stdenv.lib;{
    description = "A plugin to provide TLS capability to programs using TQCA";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# Warning: autotool build, will be deprecated by cmake in the future
# Warning: essentially broken, it uses some strange assumptions and I don't
# understand clearly the purpose of some variables
