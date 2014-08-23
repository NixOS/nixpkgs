{stdenv, fetchurl, fetchgit, qt4, qca2, openssl, which}:

stdenv.mkDerivation rec {
  version = "2.0.0-beta3";
  name = "qca-ossl-${version}";
  src = fetchurl {
    url = "http://delta.affinix.com/download/qca/2.0/plugins/${name}.tar.bz2";
    sha256 = "0yy68racvx3clybry2i1bw5bz9yhxr40p3xqagxxb15ihvsrzq08";
  };
  # SVN version has stabilized and has a lot of fixes for fresh OpenSSL
  # Take the main source from there
  git_src = fetchgit {
    url = git://anongit.kde.org/qca;
    rev = "0a8b9db6613f2282fe492ff454412f502a6be410";
    sha256 =  "1ebb97092f21b9152c6dda56cb33795bea4e83c82800848e800ddaaaf23a31e1";
  };
  buildInputs = [ qt4 qca2 openssl ];
  nativeBuildInputs = [ which ];
  dontAddPrefix = true;
  configureFlags="--no-separate-debug-info --with-qca=${qca2}
    --with-openssl-inc=${openssl}/include --with-openssl-lib=${openssl}/lib";
  preConfigure=''
    cp ${git_src}/plugins/qca-ossl/qca-ossl.cpp .

    configureFlags="$configureFlags --plugins-path=$out/lib/qt4/plugins"
  '';
  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture OpenSSL plugin";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.urkud ];
  };
}
