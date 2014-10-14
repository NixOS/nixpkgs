{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec{
  name = "libqb-0.16.0";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/q/u/quarterback/${name}.tar.xz";
    sha256 = "0j3zl5g5nnx98jb16p89q8w61har3gbvnlnmma8yj31xngps3kdq";
  };

  buildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/clusterlabs/libqb;
    description = "a library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
