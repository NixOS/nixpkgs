{ stdenv, fetchurl, libibverbs }:

stdenv.mkDerivation rec {
  name = "librdmacm-${version}";
  version = "1.0.21";

  src = fetchurl {
    url = "https://www.openfabrics.org/downloads/rdmacm/${name}.tar.gz";
    sha256 = "0yx2wr5dvmf5apvc4f4r2f2mlvn05piwvxsqfb60p3rk4jfx56dx";
  };

  buildInputs = [ libibverbs ];

  postInstall = ''
    mkdir -p $out/lib/pkgconfig
    cat >$out/lib/pkgconfig/rdmacm.pc <<EOF
    prefix=$out
    exec_prefix=\''${prefix}
    libdir=\''${exec_prefix}/lib
    includedir=\''${prefix}/include

    Name: RDMA library
    Version: ${version}
    Description: Library for managing RDMA connections
    Libs: -L\''${libdir} -lrdmacm
    Cflags: -I\''${includedir}
    EOF
  '';

  meta = with stdenv.lib; {
    homepage = https://www.openfabrics.org/;
    platforms = with platforms; linux ++ freebsd;
    license = licenses.bsd2;
    maintainers = with maintainers; [ wkennington ];
  };
}
