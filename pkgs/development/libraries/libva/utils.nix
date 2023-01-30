{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config
, libdrm, libva, libX11, libXext, libXfixes, wayland
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  version = "2.17.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "sha256-xsKOoDVt6L3L+6uBrKo/pyeHvQ4GgH312WKesT8XVLs=";
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
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
