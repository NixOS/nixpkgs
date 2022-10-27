{ stdenv, fetchFromGitHub, lib, cmake, pkg-config, libftdi1 }:

stdenv.mkDerivation rec {
  pname = "jtag-remote-server";
  version = "unstable-2022-06-09";

  src = fetchFromGitHub {
    owner = "jiegec";
    repo = pname;
    rev = "917d8d298423ba1aa6e75aa92e009b7f27f74a57";
    hash = "sha256-Jy0OyRgn9SYpjP3HYWPvRirfxXk4/vMYvZuI3XpPtBw=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libftdi1 ];

  meta = with lib; {
    description = "Remote JTAG server for remote debugging";
    homepage = "https://github.com/jiegec/jtag-remote-server";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.unix;
  };
}
