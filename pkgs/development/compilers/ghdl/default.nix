{ stdenv, fetchFromGitHub, gnat, zlib, llvm, lib
, backend ? "mcode" }:

assert backend == "mcode" || backend == "llvm";

stdenv.mkDerivation rec {
  pname = "ghdl-${backend}";
  # NOTE(aseipp): move to 0.38 when it comes out, since it should support a stable
  # version of the yosys plugin
  version = "unstable-2021.01.14";

  src = fetchFromGitHub {
    owner  = "ghdl";
    repo   = "ghdl";
    rev    = "4868294436574660552ccef50a5b0849559393de";
    sha256 = "1wqjf0qc66dam1n2mskmlvj53bcsdwwk5rq9gimq6ah1vcwi222p";
  };

  LIBRARY_PATH = "${stdenv.cc.libc}/lib";

  buildInputs = [ gnat zlib ];

  preConfigure = ''
    # If llvm 7.0 works, 7.x releases should work too.
    sed -i 's/check_version 7.0/check_version 7/g' configure
  '';

  configureFlags = [ "--enable-synth" ] ++ lib.optional (backend == "llvm")
    "--with-llvm-config=${llvm}/bin/llvm-config";

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ghdl/ghdl";
    description = "VHDL 2008/93/87 simulator";
    maintainers = with maintainers; [ lucus16 thoughtpolice ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
