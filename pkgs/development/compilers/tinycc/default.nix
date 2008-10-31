{ stdenv, fetchurl, perl, texinfo }:

let version = "0.9.24"; in
  stdenv.mkDerivation {
    name = "tinycc-${version}";

    src = fetchurl {
      url = "mirror://savannah/tinycc/tcc-${version}.tar.bz2";
      sha256 = "0yafz627ky0lhppa6g1mfmisnis745m39l15aixmmv5n383x9bi7";
    };

    buildInputs = [ perl texinfo ];

    patchPhase = ''
      substituteInPlace "texi2pod.pl" \
        --replace "/usr/bin/perl" "${perl}/bin/perl"

      # To produce executables, `tcc' needs to know where `crt*.o' are.
      sed -i "tcc.c" \
        -e's|define CONFIG_TCC_CRT_PREFIX.*$|define CONFIG_TCC_CRT_PREFIX "${stdenv.glibc}/lib"|g ;
           s|tcc_add_library_path(s, "/usr/lib");|tcc_add_library_path(s, "${stdenv.glibc}/lib");|g'

      # Tell it about the loader's location.
      sed -i "tccelf.c" \
        -e's|".*/ld-linux\([^"]\+\)"|"${stdenv.glibc}/lib/ld-linux\1"|g'
    '';

    postInstall = ''
      makeinfo --force tcc-doc.texi || true

      ensureDir "$out/share/info"
      mv tcc-doc.info* "$out/share/info"
    '';

    meta = {
      description = "TinyCC, a small, fast, and embeddable C compiler and interpreter";
      homepage = http://www.tinycc.org/;
      license = "LGPLv2+";
    };
  }
