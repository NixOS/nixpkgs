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

stdenv.mkDerivation rec {
  pname = "ghdl-${backend}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl";
    rev    = "v${version}";
    sha256 = "sha256-B/G3FGRzYy4Y9VNNB8yM3FohiIjPJhYSVbqsTN3cL5k=";
  };

  patches = [
    # https://github.com/ghdl/ghdl/issues/2056
    (fetchpatch {
      name = "fix-build-gcc-12.patch";
      url = "https://github.com/ghdl/ghdl/commit/f8b87697e8b893b6293ebbfc34670c32bfb49397.patch";
      hash = "sha256-tVbMm8veFkNPs6WFBHvaic5Jkp1niyg0LfFufa+hT/E=";
    })
  ];

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

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  passthru = {
    # run with either of
    # nix-build -A ghdl-mcode.passthru.tests
    # nix-build -A ghdl-llvm.passthru.tests
    tests = {
      simple = callPackage ./test-simple.nix { inherit backend; };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    maintainers = with maintainers; [ lucus16 thoughtpolice ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
