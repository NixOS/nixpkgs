{ stdenv, fetchFromGitHub, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  version = "0.57.0";
  name = "folly-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "12b9bkwmndfwmsknc209kpplxn9wqmwr3p2h0l2szrppq4qqyfq9";
  };

  nativeBuildInputs = [ autoreconfHook python ];
  buildInputs = [ libiberty boost libevent double_conversion glog google-gflags openssl ];

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
    maintainers = with maintainers; [ abbradar ];
  };
}
