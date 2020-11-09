{ callPackage
, stdenvNoCC
, fetchurl
, rpmextract
, undmg
, darwin
, validatePkgConfig
, enableStatic ? false
}:

/*
  For details on using mkl as a blas provider for python packages such as numpy,
  numexpr, scipy, etc., see the Python section of the NixPkgs manual.
*/
let
  # Release notes and download URLs are here:
  # https://registrationcenter.intel.com/en/products/
  version = "${year}.${spot}.${rel}";

  # Darwin is pinned to 2019.3 because the DMG does not unpack; see here for details:
  # https://github.com/matthewbauer/undmg/issues/4
  year = if stdenvNoCC.isDarwin then "2019" else "2020";
  spot = if stdenvNoCC.isDarwin then "3" else "3";
  rel = if stdenvNoCC.isDarwin then "199" else "279";

  # Replace `openmpSpot` by `spot` after 2020.3. Release 2020.03
  # adresses performance regressions and does not update OpenMP.
  openmpSpot = if stdenvNoCC.isDarwin then spot else "2";

  rpm-ver = "${year}.${spot}-${rel}-${year}.${spot}-${rel}";

  # Intel openmp uses its own versioning, but shares the spot release patch.
  openmp = if stdenvNoCC.isDarwin then "19.0" else "19.1";
  openmp-ver = "${openmp}.${openmpSpot}-${rel}-${openmp}.${openmpSpot}-${rel}";

  shlibExt = stdenvNoCC.hostPlatform.extensions.sharedLibrary;

in stdenvNoCC.mkDerivation {
  pname = "mkl";
  inherit version;

  src = if stdenvNoCC.isDarwin
    then
      (fetchurl {
        url = "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/15235/m_mkl_${version}.dmg";
        sha256 = "14b3ciz7995sqcd6jz7hc8g2x4zwvqxmgxgni46vrlb7n523l62f";
      })
    else
      (fetchurl {
        url = "https://registrationcenter-download.intel.com/akdlm/irc_nas/tec/16903/l_mkl_${version}.tgz";
        sha256 = "013shn3c823bjfssq4jyl3na5lbzj99s09ds608ljqllri7473ib";
      });

  nativeBuildInputs = [ validatePkgConfig ] ++ (if stdenvNoCC.isDarwin
    then
      [ undmg darwin.cctools ]
    else
      [ rpmextract ]);

  buildPhase = if stdenvNoCC.isDarwin then ''
    for f in Contents/Resources/pkg/*.tgz; do
      tar xzvf $f
    done
  '' else ''
    # Common stuff
    rpmextract rpm/intel-mkl-core-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-common-c-${rpm-ver}.noarch.rpm
    rpmextract rpm/intel-mkl-common-f-${rpm-ver}.noarch.rpm

    # Dynamic libraries
    rpmextract rpm/intel-mkl-cluster-rt-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-core-rt-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-gnu-f-rt-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-gnu-rt-${rpm-ver}.x86_64.rpm

    # Intel OpenMP runtime
    rpmextract rpm/intel-openmp-${openmp-ver}.x86_64.rpm
  '' + (if enableStatic then ''
    # Static libraries
    rpmextract rpm/intel-mkl-cluster-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-gnu-${rpm-ver}.x86_64.rpm
    rpmextract rpm/intel-mkl-gnu-f-${rpm-ver}.x86_64.rpm
  '' else ''
    # Take care of installing dynamic-only PkgConfig files during the installPhase
  ''
  );

  installPhase = ''
    for f in $(find . -name 'mkl*.pc') ; do
      bn=$(basename $f)
      substituteInPlace $f \
        --replace "prefix=<INSTALLDIR>/mkl" "prefix=$out" \
        --replace $\{MKLROOT} "$out" \
        --replace "lib/intel64_lin" "lib" \
        --replace "lib/intel64" "lib"
    done

    for f in $(find opt/intel -name 'mkl*iomp.pc') ; do
      substituteInPlace $f \
        --replace "../compiler/lib" "lib"
    done
  '' +
    (if stdenvNoCC.isDarwin then ''
      mkdir -p $out/lib

      cp -r compilers_and_libraries_${version}/mac/mkl/include $out/

      cp -r compilers_and_libraries_${version}/licensing/mkl/en/license.txt $out/lib/
      cp -r compilers_and_libraries_${version}/mac/compiler/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/mkl/lib/* $out/lib/
      cp -r compilers_and_libraries_${version}/mac/tbb/lib/* $out/lib/

      mkdir -p $out/lib/pkgconfig
      cp -r compilers_and_libraries_${version}/mac/mkl/bin/pkgconfig/* $out/lib/pkgconfig
  '' else ''
      mkdir -p $out/lib
      cp license.txt $out/lib/

      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/include $out/

      mkdir -p $out/lib/pkgconfig
  '') +
    (if enableStatic then ''
      cp -r opt/intel/compilers_and_libraries_${version}/linux/compiler/lib/intel64_lin/* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/bin/pkgconfig/* $out/lib/pkgconfig
    '' else ''
      cp -r opt/intel/compilers_and_libraries_${version}/linux/compiler/lib/intel64_lin/*.so* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/lib/intel64_lin/*.so* $out/lib/
      cp -r opt/intel/compilers_and_libraries_${version}/linux/mkl/bin/pkgconfig/*dynamic*.pc $out/lib/pkgconfig
    '') + ''

    # Setup symlinks for blas / lapack
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}
  '' + stdenvNoCC.lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}".3"
    ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}".3"
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

  passthru.tests.pkg-config = callPackage ./test { };

  meta = with stdenvNoCC.lib; {
    description = "Intel Math Kernel Library";
    longDescription = ''
      Intel Math Kernel Library (Intel MKL) optimizes code with minimal effort
      for future generations of Intel processors. It is compatible with your
      choice of compilers, languages, operating systems, and linking and
      threading models.
    '';
    homepage = "https://software.intel.com/en-us/mkl";
    license = licenses.issl;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ bhipple ];
  };
}
