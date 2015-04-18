{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec{
  name = "libqb-0.17.1";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/q/u/quarterback/${name}.tar.xz";
    sha256 = "0a9fy4hb6ixs875fbqw77dfj7519ixg27vg4yajyl87y7gw1a8bs";
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
