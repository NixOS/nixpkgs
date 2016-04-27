{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, boost, libevent, double_conversion, glog
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

  patches = [
    # Fix compatibility with Boost 1.59
    (fetchpatch {
      url = "https://github.com/facebook/folly/commit/29193aca605bb93d82a3c92acd95bb342115f3a4.patch";
      sha256 = "1ixpgq1wjr3i7madx4faw72n17ilc9cr435k5w1x95jr954m9j7b";
    })
  ];

  nativeBuildInputs = [ autoreconfHook python ];
  buildInputs = [ libiberty boost libevent double_conversion glog google-gflags openssl ];

  postPatch = "cd folly";
  preBuild = ''
    patchShebangs build
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

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
