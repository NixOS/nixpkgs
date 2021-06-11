{ stdenv, fetchFromGitHub, callPackage, gnat, zlib, llvm, lib
, backend ? "mcode" }:

assert backend == "mcode" || backend == "llvm";

stdenv.mkDerivation rec {
  pname = "ghdl-${backend}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl";
    rev    = "v${version}";
    sha256 = "1gyh0xckwbzgslbpw9yrpj4gqs9fm1a2qpbzl0sh143fk1kwjlly";
  };

  LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  buildInputs = [ gnat zlib ] ++ lib.optional (backend == "llvm") [ llvm ];
  propagatedBuildInputs = lib.optionals (backend == "llvm") [ zlib ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version  7.0/check_version  7/g' configure
  '';

  configureFlags = [ "--enable-synth" ] ++ lib.optional (backend == "llvm")
    "--with-llvm-config=${llvm.dev}/bin/llvm-config";

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
