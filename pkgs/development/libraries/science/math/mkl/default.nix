{ stdenvNoCC, writeText, fetchurl, rpmextract, undmg, openmp }:
/*
<<<<<<< HEAD
  Some mkl functions require openmp, but Intel does not add these to SO_NEEDED
  and instructs users to put openmp on their LD_LIBRARY_PATH. Since the mkl
  package is large and changes very infrequently, we make a fixed-output pkg
  with the extracted RPM contents, then wrap it with an openmp-dependent
  derivation with the appropriate setupHook. Note that we cannot add an
  SO_NEEDED entry directly to the library via patchelf, since the license
  prevents modification.
*/
let
=======
  For details on using mkl as a blas provider for python packages such as numpy,
  numexpr, scipy, etc., see the Python section of the NixPkgs manual.
*/
stdenvNoCC.mkDerivation rec {
  name = "mkl-${version}";
>>>>>>> upstream/master
  version = "${date}.${rel}";
  date = "2019.0";
  rel = "117";

<<<<<<< HEAD
=======
  src = if stdenvNoCC.isDarwin
    then
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13565/m_mkl_${version}.dmg";
        sha256 = "1f1jppac7vqwn00hkws0p4njx38ajh0n25bsjyb5d7jcacwfvm02";
      })
    else
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/l_mkl_${version}.tgz";
        sha256 = "1bf7i54iqlf7x7fn8kqwmi06g30sxr6nq3ac0r871i6g0p3y47sf";
      });

  buildInputs = if stdenvNoCC.isDarwin then [ undmg ] else [ rpmextract ];

  buildPhase = if stdenvNoCC.isDarwin then ''
      for f in Contents/Resources/pkg/*.tgz; do
          tar xzvf $f
      done
  '' else ''
    rpmextract rpm/intel-mkl-common-c-${date}-${rel}-${date}-${rel}.noarch.rpm
    rpmextract rpm/intel-mkl-core-rt-${date}-${rel}-${date}-${rel}.x86_64.rpm
    rpmextract rpm/intel-openmp-19.0.0-${rel}-19.0.0-${rel}.x86_64.rpm
  '';

  installPhase = if stdenvNoCC.isDarwin then ''
      mkdir -p $out/lib

      cp -r compilers_and_libraries_${version}/mac/mkl/include $out/

      cp -r compilers_and_libraries_${version}/licensing/mkl/en/license.txt $out/lib/
      cp -r compilers_and_libraries_${version}/mac/compiler/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/mkl/lib/* $out/lib/
  '' else ''
      mkdir -p $out/lib

      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/include $out/

      cp -r opt/intel/compilers_and_libraries_${version}/linux/compiler/lib/intel64_lin/* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/* $out/lib/
      cp license.txt $out/lib/
  '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

  # Since these are unmodified binaries from Intel, they do not depend on stdenv
  # and we can make them fixed-output derivations for cache efficiency.
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = if stdenvNoCC.isDarwin
    then "00d49ls9vcjan1ngq2wx2q4p6lnm05zwh67hsmj7bnq43ykrfibw"
    else "1amagcaan0hk3x9v7gg03gkw02n066v4kmjb32yyzsy5rfrivb1a";

>>>>>>> upstream/master
  meta = with stdenvNoCC.lib; {
    description = "Intel Math Kernel Library";
    longDescription = ''
      Intel Math Kernel Library (Intel MKL) optimizes code with minimal effort
      for future generations of Intel processors. It is compatible with your
      choice of compilers, languages, operating systems, and linking and
      threading models.
    '';
    homepage = https://software.intel.com/en-us/mkl;
    license = licenses.issl;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.bhipple ];
  };

  mkl-unwrapped = stdenvNoCC.mkDerivation rec {
    name = "mkl-unwrapped-${version}";

    src = if stdenvNoCC.isDarwin
      then
        (fetchurl {
          url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13565/m_mkl_${version}.dmg";
          sha256 = "1f1jppac7vqwn00hkws0p4njx38ajh0n25bsjyb5d7jcacwfvm02";
        })
      else
        (fetchurl {
          url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/l_mkl_${version}.tgz";
          sha256 = "1bf7i54iqlf7x7fn8kqwmi06g30sxr6nq3ac0r871i6g0p3y47sf";
        });

    buildInputs = if stdenvNoCC.isDarwin then [ undmg ] else [ rpmextract ];

    buildPhase = if stdenvNoCC.isDarwin then ''
        for f in Contents/Resources/pkg/*.tgz; do
            tar xzvf $f
        done
    '' else ''
      rpmextract rpm/intel-mkl-common-c-${date}-${rel}-${date}-${rel}.noarch.rpm
      rpmextract rpm/intel-mkl-core-rt-${date}-${rel}-${date}-${rel}.x86_64.rpm
    '';

    installPhase = if stdenvNoCC.isDarwin then ''
        mkdir -p $out/lib
        cp -r compilers_and_libraries_${version}/mac/mkl/include $out/
        cp -r compilers_and_libraries_${version}/mac/mkl/lib/* $out/lib/
        cp -r compilers_and_libraries_${version}/licensing/mkl/en/license.txt $out/lib/
    '' else ''
        mkdir -p $out/lib
        cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/include $out/
        cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/* $out/lib/
        cp license.txt $out/lib/
    '';

    # Per license agreement, do not modify the binary
    dontStrip = true;
    dontPatchELF = true;

    # Since these are unmodified binaries from Intel, they do not depend on stdenv
    # and we can make them fixed-output derivations for cache efficiency.
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = if stdenvNoCC.isDarwin
      then "1224dln7n8px1rk8biiggf77wjhxh8mzw0hd8zlyjm8i6j8w7i12"
      else "0d8ai0wi8drp071acqkm1wv6vyg12010y843y56zzi1pql81xqvx";

    inherit meta;
  };

  libvar = if stdenvNoCC.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
in {
  inherit mkl-unwrapped;

  mkl = stdenvNoCC.mkDerivation {
    name = "mkl-${version}";
    inherit meta;

    buildCommand = ''
      mkdir -p $out/nix-support
      for f in ${mkl-unwrapped}/*; do
          ln -s $f $out/
      done

      cat << EOM > $out/nix-support/setup-hook
      addOpenmp() {
          addToSearchPath ${libvar} ${openmp}/lib
      }
      addEnvHooks "$targetOffset" addOpenmp
      EOM
    '';
  };
}
