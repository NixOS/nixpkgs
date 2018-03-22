{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, boost, libevent
, double-conversion, glog, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2018.02.26.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "1pdb3nnly0x4x8yy1r13xgh9zhn34c9dq0b3nhxr8gwbzf643j1c";
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
