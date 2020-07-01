{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation rec {
  pname = "blas";
  version = "3.8.0";

  src = fetchurl {
    url = "http://www.netlib.org/blas/${pname}-${version}.tgz";
    sha256 = "1s24iry5197pskml4iygasw196bdhplj0jmbsb9jhabcjqj2mpsm";
  };

  buildInputs = [ gfortran ];

  configurePhase = ''
    echo >make.inc  "SHELL = ${stdenv.shell}"
    echo >>make.inc "PLAT = _LINUX"
    echo >>make.inc "FORTRAN = gfortran"
    echo >>make.inc "OPTS = -O2 -fPIC"
    echo >>make.inc "DRVOPTS = $$(OPTS)"
    echo >>make.inc "NOOPT = -O0 -fPIC"
    echo >>make.inc "LOADER = gfortran"
    echo >>make.inc "LOADOPTS ="
    echo >>make.inc "ARCH = gfortran"
    echo >>make.inc "ARCHFLAGS = -shared -o"
    echo >>make.inc "RANLIB = echo"
    echo >>make.inc "BLASLIB = libblas.so.${version}"
  '';

  buildPhase = ''
    make
    echo >>make.inc "ARCHFLAGS = "
    echo >>make.inc "BLASLIB = libblas.a"
    echo >>make.inc "ARCH = ar rcs"
    echo >>make.inc "RANLIB = ranlib"
    make
  '';

  installPhase =
    # FreeBSD's stdenv doesn't use Coreutils.
    let dashD = if stdenv.isFreeBSD then "" else "-D"; in
    (stdenv.lib.optionalString stdenv.isFreeBSD "mkdir -p $out/lib ;")
    + ''
    install ${dashD} -m755 libblas.a "$out/lib/libblas.a"
    install ${dashD} -m755 libblas.so.${version} "$out/lib/libblas.so.${version}"
    ln -s libblas.so.${version} "$out/lib/libblas.so.3"
    ln -s libblas.so.${version} "$out/lib/libblas.so"
    # Write pkgconfig alias.
    # See also openblas/default.nix
    mkdir $out/lib/pkgconfig
    cat <<EOF > $out/lib/pkgconfig/blas.pc
Name: blas
Version: ${version}
Description: blas provided by the BLAS package.
Libs: -L$out/lib -lblas
EOF
  '';

  preFixup = stdenv.lib.optionalString stdenv.isDarwin ''
    for fn in $(find $out/lib -name "*.so*"); do
      if [ -L "$fn" ]; then continue; fi
      install_name_tool -id "$fn" "$fn"
    done
  '';

  meta = {
    description = "Basic Linear Algebra Subprograms";
    license = stdenv.lib.licenses.publicDomain;
    homepage = "http://www.netlib.org/blas/";
    platforms = stdenv.lib.platforms.unix;
  };
}
