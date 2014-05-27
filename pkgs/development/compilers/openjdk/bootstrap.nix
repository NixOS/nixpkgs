{ stdenv, runCommand, glibc, fetchurl, file }:

let
  # !!! These should be on nixos.org
  src = if glibc.system == "x86_64-linux" then
    fetchurl {
      url = http://tarballs.nixos.org/openjdk-bootstrap-x86_64-linux-2012-08-24.tar.xz;
      sha256 = "0gla9dxrfq2w1hvgsnn8jg8a60k27im6z43a6iidi0qmwa0wah32";
    }
  else if glibc.system == "i686-linux" then
    fetchurl {
      url = http://tarballs.nixos.org/openjdk-bootstrap-i686-linux-2012-08-24.tar.xz;
      sha256 = "184wq212bycwbbq4ix8cc6jwjxkrqw9b01zb86q95kqpa8zy5206";
    }
  else throw "No bootstrap for system";
in

runCommand "openjdk-bootstrap" {} ''
  xz -dc ${src} | sed "s/e*-glibc-[^/]*/$(basename ${glibc})/g" | tar xv
  mv openjdk-bootstrap $out

  # Temporarily, while NixOS's OpenJDK bootstrap tarball doesn't have PaX markings:
  exes=$(${file}/bin/file $out/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
  for file in $exes; do
    paxmark m "$file"
    # On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
    ${stdenv.lib.optionalString stdenv.isi686 ''paxmark msp "$file"''}
  done
''
