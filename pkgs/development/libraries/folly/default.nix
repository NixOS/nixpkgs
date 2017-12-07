{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, boost, libevent
, double_conversion, glog, google-gflags, python, libiberty, openssl }:

stdenv.mkDerivation rec {
  name = "folly-${version}";
  version = "2017.07.24.00";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "folly";
    rev = "v${version}";
    sha256 = "1cmqrm9yjxrw4xr1kcgzl0s7vcvp125wcgb0cz7whssgj11mf169";
  };

  patches = [
    # Fix compilation
    (fetchpatch {
      url = "https://github.com/facebook/folly/commit/9fc87c83d93f092859823ec32289ed1b6abeb683.patch";
      sha256 = "0ix0grqlzm16hwa4rjbajjck8kr9lksh6c3gn7p3ihbbchsmlhvl";
    })
  ];

  nativeBuildInputs = [ autoreconfHook python pkgconfig ];
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
    license = licenses.asl20;
    # 32bit is not supported: https://github.com/facebook/folly/issues/103
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
