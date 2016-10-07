{ stdenv, fetchurl, pkgconfig
, openssl, tqtinterface, tqt3 }:

stdenv.mkDerivation rec{

  name = "tqca-tls-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "0ihbrn997w0sh2lxjikkc054igshp3x411kz899dpabrs9cq3n42";
  };
  
  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ openssl tqtinterface ];

  patchPhase = ''
    sed -i -e "s|/usr/include/tqt|${tqtinterface}/include/tqt|" tqca-tls/configure
    sed -i -e '/for p in/ s|/usr|/FAIL|g' tqca-tls/configure
  '';

  preConfigure = "cd tqca-tls";

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
