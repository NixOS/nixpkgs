{ lib, stdenv, fetchFromGitHub, runCommand, unzip, cosmopolitan,bintools-unwrapped }:

stdenv.mkDerivation rec {
  pname = "cosmopolitan";
  version = "unstable-2022-03-22";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = "5022f9e9207ff2b79ddd6de6d792d3280e12fb3a";
    sha256 = "sha256-UjL4wR5HhuXiQXg6Orcx2fKiVGRPMJk15P779BP1fRA=";
  };

  patches = [
    ./ioctl.patch        # required /dev/tty
  ];

  postPatch = ''
    patchShebangs build/
  '';

  dontConfigure = true;
  dontFixup = true;
  enableParallelBuilding = true;
  nativeBuildInputs = [ bintools-unwrapped unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,include,lib}
    install o/cosmopolitan.h $out/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} $out/lib

    cat > $out/bin/cosmoc <<EOF
    #!${stdenv.shell}
    exec ${stdenv.cc}/bin/${stdenv.cc.targetPrefix}gcc \
      -O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
      "\$@" \
      -Wl,--gc-sections -Wl,-z,max-page-size=0x1000 \
      -fuse-ld=bfd -Wl,-T,$out/lib/ape.lds \
      -include $out/include/cosmopolitan.h \
      -I $out/include \
      $out/lib/{crt.o,ape.o,cosmopolitan.a}
    EOF
    chmod +x $out/bin/cosmoc

    pushd o
    find -iname "*.com" -type f -exec install -D {} $out/{} \;
    popd
    find -iname "*.h" -type f -exec install -m644 -D {} $out/include/{} \;
    find -iname "*.inc" -type f -exec install -m644 -D {} $out/include/{} \;
    runHook postInstall
  '';

  passthru.tests = lib.optionalAttrs (stdenv.buildPlatform == stdenv.hostPlatform) {
    hello = runCommand "hello-world" { } ''
      printf '#include "libc/stdio/stdio.h"\nmain() { printf("hello world\\n"); }\n' >hello.c
      ${stdenv.cc}/bin/gcc -g -O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone -o hello.com.dbg hello.c \
        -fuse-ld=bfd -Wl,-T,${cosmopolitan}/lib/ape.lds \
        -include ${cosmopolitan}/include/cosmopolitan.h \
        -I ${cosmopolitan}/include \
        ${cosmopolitan}/lib/{crt.o,ape.o,cosmopolitan.a}
      ${stdenv.cc.bintools.bintools_bin}/bin/objcopy -S -O binary hello.com.dbg hello.com
      ./hello.com
      printf "test successful" > $out
    '';
    cosmoc = runCommand "cosmoc-hello" { } ''
      printf '#include "libc/stdio/stdio.h"\nmain() { printf("hello world\\n"); }\n' >hello.c
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
