{ stdenv
, fetchurl
, ncurses5
, python27
, target
}:

stdenv.mkDerivation rec {
  pname = "gcc-arm-bin-${target}";
  version = "9.2-2019.12";
  subdir = "9.2-2019.12";

  host = {
    aarch64-linux = "aarch64";
    # x86_64-mingw = "mingw-w64-i686";
    x86_64-linux  = "x86_64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  tgt = {
    arm = "arm-none-eabi";
    armhf = "arm-none-linux-gnueabihf";
    aarch64 = "aarch64-none-elf";
    aarch64-gnu = "aarch64-none-linux-gnu";
    aarch64be-gnu = "aarch64_be-none-linux-gnu";
  }.${target} or (throw "Unsupported target: ${target}");

  host-target = "${stdenv.hostPlatform.system}_${target}";

  src = fetchurl {
    url = "https://developer.arm.com/-/media/Files/downloads/gnu-a/${subdir}/binrel/gcc-arm-${version}-${host}-${tgt}.tar.xz";
    sha256 = {
      aarch64-linux_arm  = "0wxfkvyy0q66jlskh0c4hnmsskkl73v0j5jzba7md23wxs681rdy";
      aarch64-linux_armhf  = "1jqd9c921313zwr52sv98d2zv84snshc2471cv91p7d0kgg3wcwz";
      aarch64-linux_aarch64  = "0hzjhygmg8c4zpi8261x6wy5910vv9byjq91yd41ljs3vlxsa704";
      x86_64-linux_arm  = "136abrswxl9zhkp2w4ggblgn5z3yj4s7v7h9h4z59hqgms4jv5dc";
      x86_64-linux_armhf  = "05snm3513jcj92ff3pblc98iqw36apjg2kjc4s9s7ryklhiazfsi";
      x86_64-linux_aarch64  = "1ldn6ziqvj162c7y33psmm8r3i94llxjzb32ylh2qkwqqbkwplin";
      x86_64-linux_aarch64-gnu  = "0rkaw1v66l9bpvp3i2flhnm1dik86c53rkskkkxh9ggh64anizld";
      x86_64-linux_aarch64be-gnu  = "0migj4nv0ivnzqs7y9pam9jsvdf0a0fzkzhd52w5z8v76nk59z2m";
    }.${host-target} or (throw "Unsupported system/target: ${host-target}");
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    ln -s $out/share/doc/gcc-${tgt}/man $out/man
  '';

  dontPatchELF = true;
  dontStrip = true;

  preFixup = ''
    find $out -type f | while read f; do
      patchelf $f > /dev/null 2>&1 || continue
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f" || true
      patchelf --set-rpath ${stdenv.lib.makeLibraryPath [ "$out" stdenv.cc.cc ncurses5 python27 ]} "$f" || true
    done
  '';

  meta = with stdenv.lib; {
    description = "Pre-built GNU toolchain for ARM Cortex-A processors";
    homepage = "https://developer.arm.com/open-source/gnu-toolchain/gnu-a";
    license = with licenses; [ bsd2 gpl2 gpl3 lgpl21 lgpl3 mit ];
    maintainers = with maintainers; [ wamserma ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
