{ stdenv, runCommand, glibc, fetchurl, file }:

let
  # !!! These should be on nixos.org
  src = if glibc.system == "x86_64-linux" then
    fetchurl {
      url = http://pub.wak.io/nixos/tarballs/openjdk-bootstrap-x86_64-linux.tar.xz;
      sha256 = "13m3df54mnr2nb67284s2zf5n8y502ck47gc39lcafrh40hzjil5";
    }
  else if glibc.system == "i686-linux" then
    fetchurl {
      url = http://pub.wak.io/nixos/tarballs/openjdk-bootstrap-i686-linux.tar.xz;
      sha256 = "18kzv4h9skxg5g5c7ar2ji3qny880h5svcn207b4d6xv4sa0a6ks";
    }
  else throw "No bootstrap for system";

  bootstrap = runCommand "openjdk-bootstrap" {
    passthru.home = "${bootstrap}/lib/openjdk";
  } ''
    tar xvf ${src}
    mv openjdk-bootstrap $out

    for i in $out/bin/*; do
      patchelf --set-interpreter ${glibc}/lib/ld-linux*.so.2 $i || true
      patchelf --set-rpath ${glibc}/lib:$out/lib $i || true
    done

    # Temporarily, while NixOS's OpenJDK bootstrap tarball doesn't have PaX markings:
    exes=$(${file}/bin/file $out/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
    for file in $exes; do
      paxmark m "$file"
      # On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
      ${stdenv.lib.optionalString stdenv.isi686 ''paxmark msp "$file"''}
    done
  '';
in bootstrap
