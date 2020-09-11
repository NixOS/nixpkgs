{ stdenv, fetchFromGitHub, meson, pkg-config, ninja
, pixman, gnutls, libdrm, libjpeg_turbo, zlib, aml
}:

stdenv.mkDerivation rec {
  pname = "neatvnc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "036kzhbabbwc3gvsw8kqf6rs0gh8kgn6i0by9pxski38mi0qs1qs";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ pixman gnutls libdrm libjpeg_turbo zlib aml ];

  meta = with stdenv.lib; {
    description = "A VNC server library";
    longDescription = ''
      This is a liberally licensed VNC server library that's intended to be
      fast and neat. Goals:
      - Speed
      - Clean interface
      - Interoperability with the Freedesktop.org ecosystem
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/any1/neatvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
