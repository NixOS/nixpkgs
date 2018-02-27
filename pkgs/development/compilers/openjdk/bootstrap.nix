{ stdenv
, runCommand, fetchurl, file

, version
}:

assert stdenv.hostPlatform.libc == "glibc";

let
  # !!! These should be on nixos.org
  src = if stdenv.hostPlatform.system == "x86_64-linux" then
    (if version == "8" then
      fetchurl {
        url = "https://www.dropbox.com/s/a0lsq2ig4uguky5/openjdk8-bootstrap-x86_64-linux.tar.xz?dl=1";
        sha256 = "18zqx6jhm3lizn9hh6ryyqc9dz3i96pwaz8f6nxfllk70qi5gvks";
      }
    else if version == "7" then
      fetchurl {
        url = "https://www.dropbox.com/s/rssfbeommrfbsjf/openjdk7-bootstrap-x86_64-linux.tar.xz?dl=1";
        sha256 = "024gg2sgg4labxbc1nhn8lxls2p7d9h3b82hnsahwaja2pm1hbra";
      }
    else throw "No bootstrap for version")
  else if stdenv.hostPlatform.system == "i686-linux" then
    (if version == "8" then
      fetchurl {
        url = "https://www.dropbox.com/s/rneqjhlerijsw74/openjdk8-bootstrap-i686-linux.tar.xz?dl=1";
        sha256 = "1yx04xh8bqz7amg12d13rw5vwa008rav59mxjw1b9s6ynkvfgqq9";
      }
    else if version == "7" then
      fetchurl {
        url = "https://www.dropbox.com/s/6xe64td7eg2wurs/openjdk7-bootstrap-i686-linux.tar.xz?dl=1";
        sha256 = "0xwqjk1zx8akziw8q9sbjc1rs8s7c0w6mw67jdmmi26cwwp8ijnx";
      }
    else throw "No bootstrap for version")
  else throw "No bootstrap for system";

  bootstrap = runCommand "openjdk-bootstrap" {
    passthru.home = "${bootstrap}/lib/openjdk";
  } ''
    tar xvf ${src}
    mv openjdk-bootstrap $out

    LIBDIRS="$(find $out -name \*.so\* -exec dirname {} \; | sort | uniq | tr '\n' ':')"

    find "$out" -type f -print0 | while IFS= read -r -d "" elf; do
      isELF "$elf" || continue
      patchelf --set-interpreter $(cat "${stdenv.cc}/nix-support/dynamic-linker") "$elf" || true
      patchelf --set-rpath "${stdenv.cc.libc}/lib:$LIBDIRS" "$elf" || true
    done

    # Temporarily, while NixOS's OpenJDK bootstrap tarball doesn't have PaX markings:
    find "$out/bin" -type f -print0 | while IFS= read -r -d "" elf; do
      isELF "$elf" || continue
      paxmark m "$elf"
      # On x86 for heap sizes over 700MB disable SEGMEXEC and PAGEEXEC as well.
      ${stdenv.lib.optionalString stdenv.isi686 ''paxmark msp "$elf"''}
    done
  '';
in bootstrap
