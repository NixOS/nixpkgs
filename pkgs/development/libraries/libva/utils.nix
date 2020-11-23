{ stdenv, fetchFromGitHub, meson, ninja, pkg-config
, libdrm, libva, libX11, libXext, libXfixes, wayland
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "1viqxq9r424hvbfgjlw4zb1idsq24fqr5cz6rk47j37rcnqclj2k";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ libdrm libva libX11 libXext libXfixes wayland ];

  meta = with stdenv.lib; {
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
