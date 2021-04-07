{ lib, stdenv, fetchurl, pkg-config
, libvorbis, libtheora, speex }:

# need pkg-config so that libshout installs ${out}/lib/pkgconfig/shout.pc

stdenv.mkDerivation rec {
  name = "libshout-2.4.5";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/libshout/${name}.tar.gz";
    sha256 = "sha256-2eVoZopnOZTr4/HrXyvuBuMjal25K40MSH4cD4hqaJA=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libvorbis libtheora speex ];

  meta = {
    description = "icecast 'c' language bindings";

    longDescription = ''
      Libshout is a library for communicating with and sending data to an icecast
      server.  It handles the socket connection, the timing of the data, and prevents
      bad data from getting to the icecast server.
    '';

    homepage = "http://www.icecast.org";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jcumming ];
    platforms = with lib.platforms; unix;
  };
}
