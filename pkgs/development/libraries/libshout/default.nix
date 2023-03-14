{ lib, stdenv, fetchurl, pkg-config
, libvorbis, libtheora, speex }:

# need pkg-config so that libshout installs ${out}/lib/pkgconfig/shout.pc

stdenv.mkDerivation rec {
  pname = "libshout";
  version = "2.4.6";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/libshout/${pname}-${version}.tar.gz";
    sha256 = "sha256-OcvU8O/f3cl1XYghfkf48tcQj6dn+dWKK6JqFtj3yRA=";
  };

  outputs = [ "out" "dev" "doc" ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ libvorbis libtheora speex ];

  meta = {
    description = "icecast 'c' language bindings";

    longDescription = ''
      Libshout is a library for communicating with and sending data to an icecast
      server.  It handles the socket connection, the timing of the data, and prevents
      bad data from getting to the icecast server.
    '';

    homepage = "https://www.icecast.org";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ jcumming ];
    mainProgram = "shout";
    platforms = with lib.platforms; unix;
  };
}
