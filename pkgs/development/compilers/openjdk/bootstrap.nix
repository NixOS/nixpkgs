{ stdenv, runCommand, glibc, fetchOneOf, file

, version
}:

let
  # !!! These should be on nixos.org
  src = fetchOneOf "${glibc.system}-jdk${version}" {
    "x86_64-linux-jdk7" = {
      url = "https://www.dropbox.com/s/rssfbeommrfbsjf/openjdk7-bootstrap-x86_64-linux.tar.xz?dl=1";
      sha256 = "024gg2sgg4labxbc1nhn8lxls2p7d9h3b82hnsahwaja2pm1hbra";
    };
    "x86_64-linux-jdk8" = {
      url = "https://www.dropbox.com/s/a0lsq2ig4uguky5/openjdk8-bootstrap-x86_64-linux.tar.xz?dl=1";
      sha256 = "18zqx6jhm3lizn9hh6ryyqc9dz3i96pwaz8f6nxfllk70qi5gvks";
    };
    "i686-linux-jdk7" = {
      url = "https://www.dropbox.com/s/6xe64td7eg2wurs/openjdk7-bootstrap-i686-linux.tar.xz?dl=1";
      sha256 = "0xwqjk1zx8akziw8q9sbjc1rs8s7c0w6mw67jdmmi26cwwp8ijnx";
    };
    "i686-linux-jdk8" = {
      url = "https://www.dropbox.com/s/rneqjhlerijsw74/openjdk8-bootstrap-i686-linux.tar.xz?dl=1";
      sha256 = "1yx04xh8bqz7amg12d13rw5vwa008rav59mxjw1b9s6ynkvfgqq9";
    };
  };

  bootstrap = runCommand "openjdk-bootstrap" {
    passthru.home = "${bootstrap}/lib/openjdk";
  } ''
    tar xvf ${src}
    mv openjdk-bootstrap $out

    LIBDIRS="$(find $out -name \*.so\* -exec dirname {} \; | sort | uniq | tr '\n' ':')"

    for i in $out/bin/*; do
      patchelf --set-interpreter ${glibc.out}/lib/ld-linux*.so.2 $i || true
      patchelf --set-rpath "${glibc.out}/lib:$LIBDIRS" $i || true
    done

    find $out -name \*.so\* | while read lib; do
      patchelf --set-interpreter ${glibc.out}/lib/ld-linux*.so.2 $lib || true
      patchelf --set-rpath "${glibc.out}/lib:${stdenv.cc.cc.lib}/lib:$LIBDIRS" $lib || true
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
