{ stdenv, fetchFromGitHub, automake, autoconf, libtool, autoreconfHook, gmpxx
, optimize ? false # impure
}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "givaro";
  version = "4.0.4";
  src = fetchFromGitHub {
    owner = "linbox-team";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "199p8wyj5i63jbnk7j8qbdbfp5rm2lpmcxyk3mdjy9bz7ygx3hhy";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [autoconf automake libtool gmpxx];

  configureFlags = [
    "--disable-optimization"
  ] ++ stdenv.lib.optionals (!optimize) [
    # disable SIMD instructions (which are enabled *when available* by default)
    "--disable-sse"
    "--disable-sse2"
    "--disable-sse3"
    "--disable-ssse3"
    "--disable-sse41"
    "--disable-sse42"
    "--disable-avx"
    "--disable-avx2"
    "--disable-fma"
    "--disable-fma4"
  ];

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
