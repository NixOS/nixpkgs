{ stdenv, fetchFromGitHub, autoreconfHook, boost, libevent, double_conversion, glog
, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  version = "2015-09-17";
  name = "folly-${version}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "e4527fb5d04f5fec823bd6a2402b620a6e1a64e3";
    sha256 = "0iicq19yylafr7qs221xgk8pcwf6nnyx6srgsx9y9cyf72siadcb";
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
