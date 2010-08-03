{stdenv, fetchurl, fetchsvn, qt4, qca2, openssl}:

stdenv.mkDerivation rec {
  version = "2.0.0-beta3";
  name = "qca-ossl-${version}";
  src = fetchurl {
    url = "http://delta.affinix.com/download/qca/2.0/plugins/${name}.tar.bz2";
    sha256 = "0yy68racvx3clybry2i1bw5bz9yhxr40p3xqagxxb15ihvsrzq08";
  };
  # SVN version has stabilized and has a lot of fixes for fresh OpenSSL
  # Take the main source from there
  svn_src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qca/plugins/qca-ossl ; 
    rev = 1115936;
    sha256 =  "ef2c0307e8834e1e7cb23b6fea1cc22486328a37186301a6c11161b1c93d834b";
  };
  buildInputs = [ qt4 qca2 openssl ];
  dontAddPrefix = true;
  configureFlags="--no-separate-debug-info --with-qca=${qca2}
    --with-openssl-inc=${openssl}/include --with-openssl-lib=${openssl}/lib";
  preConfigure=''
    cp ${svn_src}/qca-ossl.cpp .

    configureFlags="$configureFlags --plugins-path=$out/lib/qt4/plugins"
  '';
  meta = with stdenv.lib; {
    description = "Qt Cryptographic Architecture OpenSSL plugin";
    license = "LGPL";
    homepage = http://delta.affinix.com/qca;
    maintainers = [ maintainers.urkud ];
  };
}
