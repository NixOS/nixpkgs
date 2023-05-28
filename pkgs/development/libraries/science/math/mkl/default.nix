{ lib
, stdenv
, callPackage
, stdenvNoCC
, fetchurl
, rpmextract
, _7zz
, darwin
, validatePkgConfig
, enableStatic ? stdenv.hostPlatform.isStatic
}:

/*
  For details on using mkl as a blas provider for python packages such as numpy,
  numexpr, scipy, etc., see the Python section of the NixPkgs manual.
*/
let
  # Release notes and download URLs are here:
  # https://registrationcenter.intel.com/en/products/
  version = "${mklVersion}.${rel}";

  mklVersion = "2023.1.0";
  rel = if stdenvNoCC.isDarwin then "43558" else "46342";

  # Intel openmp uses its own versioning.
  openmpVersion = "2023.1.0";
  openmpRel = "46305";

  # Thread Building Blocks release.
  tbbVersion = "2021.9.0";
  tbbRel = "43484";

  shlibExt = stdenvNoCC.hostPlatform.extensions.sharedLibrary;

  oneapi-mkl = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-${mklVersion}-${mklVersion}-${rel}.x86_64.rpm";
    hash = "sha256-BeI5zB0rrE6C21dezNc7/WSKmTWpjsZbpg0/y0Y87VQ=";
  };

  oneapi-mkl-common = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-common-${mklVersion}-${mklVersion}-${rel}.noarch.rpm";
    hash = "sha256-NjIqTeFppwjXFlPYHPHfZa/bWBiHJru3atC4fIMXN0w=";
  };

  oneapi-mkl-common-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-common-devel-${mklVersion}-${mklVersion}-${rel}.noarch.rpm";
    hash = "sha256-GX19dlvBWRgwSOCmWcEOrnbmp4S2j0448fWpx+iPVWw=";
  };

  oneapi-mkl-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-devel-${mklVersion}-${mklVersion}-${rel}.x86_64.rpm";
    hash = "sha256-F4XxtSPAjNaShEL/l44jJK+JdOOkYI19X/njRB6FkNw=";
  };

  oneapi-openmp = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-openmp-${mklVersion}-${mklVersion}-${openmpRel}.x86_64.rpm";
    hash = "sha256-1SlkI01DxFvwGPBJ73phs86ka0SmCrniwiXQ9DJwIXw=";
  };

  oneapi-tbb = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-tbb-${tbbVersion}-${tbbVersion}-${tbbRel}.x86_64.rpm";
    hash = "sha256-wIktdf1p1SS1KrnUlc8LPkm0r9dhZE6cQNr4ZKTWI6A=";
  };

in stdenvNoCC.mkDerivation ({
  pname = "mkl";
  inherit version;

  dontUnpack = stdenvNoCC.isLinux;

  unpackPhase = if stdenvNoCC.isDarwin then ''
    7zz x $src
  '' else null;

  nativeBuildInputs = [ validatePkgConfig ] ++ (if stdenvNoCC.isDarwin
    then
      [ _7zz darwin.cctools ]
    else
      [ rpmextract ]);

  buildPhase = if stdenvNoCC.isDarwin then ''
    for f in bootstrapper.app/Contents/Resources/packages/*/cupPayload.cup; do
      tar -xf $f
    done
    mkdir -p opt/intel
    mv _installdir opt/intel/oneapi
  '' else ''
    rpmextract ${oneapi-mkl}
    rpmextract ${oneapi-mkl-common}
    rpmextract ${oneapi-mkl-common-devel}
    rpmextract ${oneapi-mkl-devel}
    rpmextract ${oneapi-openmp}
    rpmextract ${oneapi-tbb}
  '';

  installPhase = ''
    for f in $(find . -name 'mkl*.pc') ; do
      bn=$(basename $f)
      substituteInPlace $f \
        --replace $\{MKLROOT} "$out" \
        --replace "lib/intel64" "lib"

      sed -r -i "s|^prefix=.*|prefix=$out|g" $f
    done

    for f in $(find opt/intel -name 'mkl*iomp.pc') ; do
      substituteInPlace $f --replace "../compiler/lib" "lib"
    done

    # License
    install -Dm0655 -t $out/share/doc/mkl opt/intel/oneapi/mkl/${mklVersion}/licensing/license.txt

    # Dynamic libraries
    mkdir -p $out/lib
    cp -a opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
    cp -a opt/intel/oneapi/compiler/${mklVersion}/${if stdenvNoCC.isDarwin then "mac" else "linux"}/compiler/lib/${lib.optionalString stdenvNoCC.isLinux "intel64_lin"}/*${shlibExt}* $out/lib
    cp -a opt/intel/oneapi/tbb/${tbbVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64/gcc4.8"}/*${shlibExt}* $out/lib

    # Headers
    cp -r opt/intel/oneapi/mkl/${mklVersion}/include $out/

    # CMake config
    cp -r opt/intel/oneapi/mkl/${mklVersion}/lib/cmake $out/lib
  '' +
    (if enableStatic then ''
      install -Dm0644 -t $out/lib opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*.a
      install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mklVersion}/lib/pkgconfig/*.pc
    '' else ''
      cp opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
      install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mklVersion}/lib/pkgconfig/*dynamic*.pc
    '') + ''
    # Setup symlinks for blas / lapack
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}
  '' + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}".3"
  '';

  # fixDarwinDylibName fails for libmkl_cdft_core.dylib because the
  # larger updated load commands do not fit. Use install_name_tool
  # explicitly and ignore the error.
  postFixup = lib.optionalString stdenvNoCC.isDarwin ''
    for f in $out/lib/*.dylib; do
      install_name_tool -id $out/lib/$(basename $f) $f || true
    done
    install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libmkl_intel_thread.dylib
    install_name_tool -change @rpath/libtbb.12.dylib $out/lib/libtbb.12.dylib $out/lib/libmkl_tbb_thread.dylib
    install_name_tool -change @rpath/libtbbmalloc.2.dylib $out/lib/libtbbmalloc.2.dylib $out/lib/libtbbmalloc_proxy.dylib
  '';

  # Per license agreement, do not modify the binary
  dontStrip = true;
  dontPatchELF = true;

  passthru.tests = {
    pkg-config-dynamic-iomp = callPackage ./test { enableStatic = false; execution = "iomp"; };
    pkg-config-static-iomp = callPackage ./test { enableStatic = true; execution = "iomp"; };
    pkg-config-dynamic-seq = callPackage ./test { enableStatic = false; execution = "seq"; };
    pkg-config-static-seq = callPackage ./test { enableStatic = true; execution = "seq"; };
  };

  meta = with lib; {
    description = "Intel OneAPI Math Kernel Library";
    longDescription = ''
      Intel OneAPI Math Kernel Library (Intel oneMKL) optimizes code with minimal
      effort for future generations of Intel processors. It is compatible with your
      choice of compilers, languages, operating systems, and linking and
      threading models.
    '';
    homepage = "https://software.intel.com/en-us/mkl";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.issl;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ bhipple ];
  };
} // lib.optionalAttrs stdenvNoCC.isDarwin {
  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/087a9190-9d96-4b8c-bd2f-79159572ed89/m_onemkl_p_${mklVersion}.${rel}_offline.dmg";
    hash = "sha256-bUaaJPSaLr60fw0DzDCjPvY/UucHlLbCSLyQxyiAi04=";
  };
})
