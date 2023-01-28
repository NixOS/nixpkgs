{ stdenv
, lib
, fetchFromGitHub
, fetchurl

, gcc12
, glibc
, newlib
, gdb
, qemu
, musl
, spike
, riscv-pk

, autoconf
, curl
, automake
, python3
, libmpc
, gawk
, bison
, flex
, texinfo
, gperf
, libtool
, expat
, gmp
, mpfr
, flock
, zlib

, srcs ? {
  binutils = {
    url = "mirror://gnu/binutils/binutils-2.39.tar.bz2";
    hash = "sha256-2iSoT+8iAQLdJAQt8G/eqFHCYUpTd/hu/6KPM7exYUg=";
  };
  dejagnu = {
    url = "mirror://gnu/dejagnu/dejagnu-1.6.3.tar.gz";
    hash = "sha256-h9rvrNeVi0pp+IxoVtvRY0JhljxBQHnQw3H1ic1mouM=";
  };
  gcc = gcc12.cc.src;
  glibc = glibc.src;
  newlib = newlib.src;
  gdb = gdb.src;
  qemu = qemu.src;
  musl = musl.src;
  spike = spike.src;
  pk = riscv-pk.src;
}

, isa ? "rv64gc"
, withLinux ? false
}:
let

extract = file: stdenv.mkDerivation {
  name = file.name + "-unpacked";
  src = file;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = "cp -r . $out";
  dontFixup = true;
};

srcs_fetched = lib.mapAttrs (name: value: if value ? outPath then value else fetchurl value) srcs;
srcs_extracted = lib.mapAttrs (name: value: extract value) srcs_fetched;
srcFlags = lib.mapAttrsToList (name: value: "--with-${name}-src=${value}") srcs_extracted;

in stdenv.mkDerivation rec {
  pname = "riscv-gnu-toolchain-" + isa;
  version = "2023.01.04";

  src = fetchFromGitHub {
    owner = "riscv-collab";
    repo = "riscv-gnu-toolchain";
    rev = version;
    hash = "sha256-PXPQ/ho+fOudZRErnyQZTVFdceWGBF+geo+3y0tkNm4=";
  };

  nativeBuildInputs = [ autoconf automake flock curl python3 gawk bison flex texinfo gperf ];
  buildInputs = [ libmpc libtool expat gmp mpfr zlib ];
  hardeningDisable = [ "format" ];

  patches = [ ./no-dot-git.patch ];
  configureFlags = [
    "--with-arch=${isa}"
  ]
  ++ srcFlags
  ++ lib.optional withLinux "--enable-linux";

  meta = with lib; {
    homepage = "https://github.com/riscv-collab/riscv-gnu-toolchain";
    description = "RISC-V C and C++ cross-compiler";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = with licenses; [ bsd3 gpl2 lgpl21 ];
    broken = stdenv.isDarwin;
  };
}
