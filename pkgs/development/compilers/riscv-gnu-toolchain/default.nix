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

, srcs ? {
  binutils = {
    url = "mirror://gnu/binutils/binutils-2.39.tar.bz2";
    hash = "sha256-2iSoT+8iAQLdJAQt8G/eqFHCYUpTd/hu/6KPM7exYUg=";
  };
  dejagnu = {
    url = "mirror://gnu/dejagnu/dejagnu-1.6.3.tar.gz";
    hash = "sha256-h9rvrNeVi0pp+IxoVtvRY0JhljxBQHnQw3H1ic1mouM=";
  };
  gcc = {
    url = gcc12.cc.src.url;
    hash = gcc12.cc.src.outputHash;
  };
  glibc = {
    url = glibc.src.url;
    hash = glibc.src.outputHash;
  };
  newlib = {
    url = newlib.src.url;
    hash = "sha256-8pbjcvUTJCJNOHzBFtw3pr05cZh1Z0b5OisC6aXUAVQ=";
  };
  gdb = {
    url = gdb.src.url;
    hash = gdb.src.outputHash;
  };
  qemu = {
    url = qemu.src.url;
    hash = qemu.src.outputHash;
  };
  musl = {
    url = musl.src.url;
    hash = musl.src.outputHash;
  };
  spike = {
    url = spike.src.url;
    hash = "sha256-mynCIP7R6GfjvqS1xWXyYpI31SWk2f4WaGmcRAYAOh8=";
  };
  pk = {
    url = riscv-pk.src.url;
    hash = "sha256-Rf6ACDD0WptZK6XU/bdDo+TCEmZT+DTZBKXKuScQf/Y=";
  };
}

, isa ? "rv64gc"
, withLinux ? false
}:
with lib;
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

srcs_fetched = mapAttrs (name: value: if value ? outPath then value else fetchurl value) srcs;
srcs_extracted = mapAttrs (name: value: extract value) srcs_fetched;
srcFlags = mapAttrsToList (name: value: "--with-${name}-src=${value}") srcs_extracted;

in stdenv.mkDerivation rec {
  pname = "riscv-gnu-toolchain-" + isa;
  version = "2023.01.04";

  buildInputs = [ autoconf automake flock curl python3 libmpc gawk bison flex texinfo gperf libtool expat.dev gmp.dev mpfr.dev ];
  hardeningDisable = [ "format" ];

  patches = [ ./nodotgit.patch ];
  configureFlags = [
      "--with-arch=${isa}"
    ] ++
    srcFlags ++
    optional withLinux "--enable-linux";

  preConfigure = ''
    patchShebangs .
  '';

  src = fetchFromGitHub {
    owner = "riscv-collab";
    repo = pname;
    rev = version;
    hash = "sha256-PXPQ/ho+fOudZRErnyQZTVFdceWGBF+geo+3y0tkNm4=";
  };

  meta = with lib; {
    homepage = "https://github.com/riscv-collab/riscv-gnu-toolchain";
    description = "RISC-V C and C++ cross-compiler";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = with licenses; [ bsd3 gpl2 lgpl21 ];
  };
}
