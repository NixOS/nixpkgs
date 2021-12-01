{ lib, stdenv, fetchFromGitHub, pkg-config, directfb, libsigcxx, libxml2, fontconfig }:

# TODO: optional deps: baresip, FusionDale, FusionSound, SaWMan, doxygen,
# Reflex, Wnn, NLS

stdenv.mkDerivation rec {
  pname = "ilixi";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ilixi";
    repo = "ilixi";
    rev = version;
    sha256 = "05h862r9mhis26v8yf967n86qf8y1gdgfzhbqfsr6pjw1k3v3wdr";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ directfb libsigcxx libxml2 fontconfig ];

  configureFlags = [
    "--enable-log-debug"
    "--enable-debug"
    "--enable-trace"
    "--with-examples"
  ];

  meta = with lib; {
    description = "Lightweight C++ GUI toolkit for embedded Linux systems";
    homepage = "https://github.com/ilixi/ilixi";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    broken = true; # broken by the directfb 1.6.3 -> 1.7.6 update
  };
}
