{ stdenv
, fetchFromGitHub
, fetchpatch
, callPackage
, gnat
, zlib
, llvm
, lib
, backend ? "mcode"
}:

assert backend == "mcode" || backend == "llvm";

stdenv.mkDerivation (finalAttrs: {
  pname = "ghdl-${backend}";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl";
    rev    = "v${finalAttrs.version}";
    hash   = "sha256-tPSHer3qdtEZoPh9BsEyuTOrXgyENFUyJqnUS3UYAvM=";
  };

  LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  nativeBuildInputs = [
    gnat
  ];
  buildInputs = [
    zlib
  ] ++ lib.optionals (backend == "llvm") [
    llvm
  ];
  propagatedBuildInputs = [
  ] ++ lib.optionals (backend == "llvm") [
    zlib
  ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  '';

  configureFlags = [
    # See https://github.com/ghdl/ghdl/pull/2058
    "--disable-werror"
    "--enable-synth"
  ] ++ lib.optionals (backend == "llvm") [
    "--with-llvm-config=${llvm.dev}/bin/llvm-config"
  ];

  enableParallelBuilding = true;

  passthru = {
    # run with either of
    # nix-build -A ghdl-mcode.passthru.tests
    # nix-build -A ghdl-llvm.passthru.tests
    tests = {
      simple = callPackage ./test-simple.nix { inherit backend; };
    };
  };

  meta = {
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ghdl";
    maintainers = with lib.maintainers; [ lucus16 thoughtpolice ];
    platforms = lib.platforms.linux;
  };
})
