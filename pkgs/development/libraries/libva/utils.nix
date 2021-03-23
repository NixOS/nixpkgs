{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config
, libdrm, libva, libX11, libXext, libXfixes, wayland
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "130h1y67p5ig4pd7l56kncb93mws1i3zf6cklzhyj41f2k2lxayd";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ libdrm libva libX11 libXext libXfixes wayland ];

  meta = with lib; {
    description = "A collection of utilities and examples for VA-API";
    longDescription = ''
      libva-utils is a collection of utilities and examples to exercise VA-API
      in accordance with the libva project.
    '';
    homepage = "https://github.com/intel/libva-utils";
    changelog = "https://raw.githubusercontent.com/intel/libva-utils/${version}/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ primeos ];
    platforms = platforms.unix;
  };
}
