{ lib, gcc9Stdenv, fetchFromGitHub, runCommand, cosmopolitan }:

gcc9Stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = version;
    sha256 = "sha256-OVdOObO82W6JN63OWKHaERS7y0uvgxt+WLp6Y0LsmJk=";
  };

  postPatch = ''
    patchShebangs build/
    rm -r third_party/gcc
  '';

  dontConfigure = true;
  dontFixup = true;
  enableParallelBuilding = true;

  preBuild = ''
    makeFlagsArray=(
      SHELL=/bin/sh
      AS=${gcc9Stdenv.cc.targetPrefix}as
      CC=${gcc9Stdenv.cc.targetPrefix}gcc
      GCC=${gcc9Stdenv.cc.targetPrefix}gcc
      CXX=${gcc9Stdenv.cc.targetPrefix}g++
      LD=${gcc9Stdenv.cc.targetPrefix}ld
      OBJCOPY=${gcc9Stdenv.cc.targetPrefix}objcopy
      "MKDIR=mkdir -p"
      )
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib/include}
    install o/cosmopolitan.h $out/lib/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} $out/lib
    cat > $out/bin/cosmoc <<EOF
    #!${gcc9Stdenv.shell}
    exec ${gcc9Stdenv.cc}/bin/${gcc9Stdenv.cc.targetPrefix}gcc \
      -O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
      "\$@" \
      -Wl,--oformat=binary -Wl,--gc-sections -Wl,-z,max-page-size=0x1000 \
      -fuse-ld=bfd -Wl,-T,$out/lib/ape.lds \
      -include $out/lib/{include/cosmopolitan.h,crt.o,ape.o,cosmopolitan.a}
    EOF
    chmod +x $out/bin/cosmoc
    runHook postInstall
  '';

  passthru.tests = lib.optional (gcc9Stdenv.buildPlatform == gcc9Stdenv.hostPlatform) {
    hello = runCommand "hello-world" { } ''
      printf 'main() { printf("hello world\\n"); }\n' >hello.c
      ${gcc9Stdenv.cc}/bin/gcc -g -O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone -o hello.com.dbg hello.c \
        -fuse-ld=bfd -Wl,-T,${cosmopolitan}/lib/ape.lds \
        -include ${cosmopolitan}/lib/{include/cosmopolitan.h,crt.o,ape.o,cosmopolitan.a}
      ${gcc9Stdenv.cc.bintools.bintools_bin}/bin/objcopy -S -O binary hello.com.dbg hello.com
      ./hello.com
      printf "test successful" > $out
    '';
    cosmoc = runCommand "cosmoc-hello" { } ''
      printf 'main() { printf("hello world\\n"); }\n' >hello.c
      ${cosmopolitan}/bin/cosmoc hello.c
      ./a.out
      printf "test successful" > $out
    '';
  };

  meta = with lib; {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Your build-once run-anywhere c library";
    platforms = platforms.x86_64;
    badPlatforms = platforms.darwin;
    license = licenses.isc;
    maintainers = with maintainers; [ lourkeur tomberek ];
  };
}
