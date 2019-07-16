{ stdenvNoCC, fetchurl, rpmextract, undmg, darwin }:
/*
  For details on using mkl as a blas provider for python packages such as numpy,
  numexpr, scipy, etc., see the Python section of the NixPkgs manual.
*/
stdenvNoCC.mkDerivation (rec {
  name = "mkl-${version}";
  version = "${date}.${rel}";
  date = "2019.3";
  rel = "199";

  src = if stdenvNoCC.isDarwin
    then
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15235/m_mkl_${version}.dmg";
        sha256 = "14b3ciz7995sqcd6jz7hc8g2x4zwvqxmgxgni46vrlb7n523l62f";
      })
    else
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15275/l_mkl_${version}.tgz";
        sha256 = "13rb2v2872jmvzcqm4fqsvhry0j2r5cn4lqql4wpqbl1yia2pph6";
      });

  nativeBuildInputs = if stdenvNoCC.isDarwin
    then
      [ undmg
        darwin.cctools
      ]
    else
      [ rpmextract ];

  buildPhase = if stdenvNoCC.isDarwin then ''
      for f in Contents/Resources/pkg/*.tgz; do
          tar xzvf $f
      done
  '' else ''
    rpmextract rpm/intel-mkl-common-c-${date}-${rel}-${date}-${rel}.noarch.rpm
    rpmextract rpm/intel-mkl-core-rt-${date}-${rel}-${date}-${rel}.x86_64.rpm
    rpmextract rpm/intel-openmp-19.0.3-${rel}-19.0.3-${rel}.x86_64.rpm
  '';

  installPhase = if stdenvNoCC.isDarwin then ''
      mkdir -p $out/lib

      cp -r compilers_and_libraries_${version}/mac/mkl/include $out/

      cp -r compilers_and_libraries_${version}/licensing/mkl/en/license.txt $out/lib/
      cp -r compilers_and_libraries_${version}/mac/compiler/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/mkl/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/tbb/lib/* $out/lib/
  '' else ''
      mkdir -p $out/lib

      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/include $out/

      cp -r opt/intel/compilers_and_libraries_${version}/linux/compiler/lib/intel64_lin/* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/* $out/lib/
      cp license.txt $out/lib/
  '';

  # fixDarwinDylibName fails for libmkl_cdft_core.dylib because the
  # larger updated load commands do not fit. Use install_name_tool
  # explicitly and ignore the error.
  postFixup = stdenvNoCC.lib.optionalString stdenvNoCC.isDarwin ''
      for f in $out/lib/*.dylib; do
          install_name_tool -id $out/lib/$(basename $f) $f || true
      done
      install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libmkl_intel_thread.dylib
      install_name_tool -change @rpath/libtbb.dylib $out/lib/libtbb.dylib $out/lib/libmkl_tbb_thread.dylib
      install_name_tool -change @rpath/libtbbmalloc.dylib $out/lib/libtbbmalloc.dylib $out/lib/libtbbmalloc_proxy.dylib
  '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

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
 } // stdenvNoCC.lib.optionalAttrs stdenvNoCC.isLinux {
  # Since on Linux binaries are unmodified, we can make them
  # fixed-output derivations.
	outputHashAlgo = "sha256";
	outputHashMode = "recursive";
	outputHash = "101krzh2mjbfx8kvxim2zphdvgg7iijhbf9xdz3ad3ncgybxbdvw";
 })
