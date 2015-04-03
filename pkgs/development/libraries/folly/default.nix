{ stdenv, fetchFromGitHub, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  version = "0.32.0";
  name = "folly-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0yviih6b220bv6d1rg4lx1hqprqapnzfv4rv64cwjxbmz49ckmzh";
  };

  buildInputs = [ libiberty boost.lib libevent double_conversion glog google-gflags openssl ];

  nativeBuildInputs = [ autoreconfHook python boost ];

  postUnpack = "sourceRoot=\${sourceRoot}/folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.mit;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = maintainers.abbradar;
  };
}
