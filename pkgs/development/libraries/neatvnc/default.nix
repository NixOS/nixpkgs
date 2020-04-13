{ stdenv, fetchFromGitHub, meson, pkg-config, ninja
, pixman, libuv, gnutls, libdrm
# libjpeg_turbo: Optional, for tight encoding (disabled because experimental)
, enableCpuAcceleration ? false # Whether to use CPU extensions (e.g. AVX)
}:

stdenv.mkDerivation rec {
  pname = "neatvnc";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "04wcpwxlcf0bczcs97j21346mn6finfj7xgc2dsrwrw9xq8qa7wc";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ pixman libuv gnutls libdrm ];

  patches = stdenv.lib.optional (!enableCpuAcceleration) ./disable-cpu-acceleration.patch;

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
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
