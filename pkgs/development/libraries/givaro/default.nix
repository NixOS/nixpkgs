{ stdenv, fetchFromGitHub, automake, autoconf, libtool, autoreconfHook, gmpxx }:
stdenv.mkDerivation rec {
  pname = "givaro";
  version = "4.1.1";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = pname;
    rev = "v${version}";
    sha256 = "11wz57q6ijsvfs5r82masxgr319as92syi78lnl9lgdblpc6xigk";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [autoconf automake libtool];
  propagatedBuildInputs = [ gmpxx ];

  configureFlags = [
    "--disable-optimization"
  ] ++ stdenv.lib.optionals stdenv.isx86_64 {
    # disable SIMD instructions (which are enabled *when available* by default)
    default        = [ "--disable-sse3" "--disable-ssse3" "--disable-sse41" "--disable-sse42" "--disable-avx" "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    westmere       = [                                                                        "--disable-avx" "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    sandybridge    = [                                                                                        "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    ivybridge      = [                                                                                        "--disable-avx2" "--disable-fma" "--disable-fma4" ];
    haswell        = [                                                                                                                         "--disable-fma4" ];
    broadwell      = [                                                                                                                         "--disable-fma4" ];
    skylake        = [                                                                                                                         "--disable-fma4" ];
    skylake-avx512 = [                                                                                                                         "--disable-fma4" ];
  }.${stdenv.hostPlatform.platform.gcc.arch or "default"};

  # On darwin, tests are linked to dylib in the nix store, so we need to make
  # sure tests run after installPhase.
  doInstallCheck = true;
  installCheckTarget = "check";
  doCheck = false;

  meta = {
    inherit version;
    description = ''A C++ library for arithmetic and algebraic computations'';
    license = stdenv.lib.licenses.cecill-b;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
