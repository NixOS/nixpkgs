{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, boost, libevent
, double-conversion, glog, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2018.06.25.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "0i0c2130xjrpzf5k29j09ckl1nc9ab2hapf5l6004axq6v1kw9sa";
  };

  nativeBuildInputs = [ autoreconfHook python pkgconfig ];
  buildInputs = [ libiberty boost libevent double-conversion glog google-gflags openssl ];

  postPatch = "cd folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An open-source C++ library developed and used at Facebook";
    homepage = https://github.com/facebook/folly;
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
