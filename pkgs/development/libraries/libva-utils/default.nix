{ stdenv, fetchFromGitHub, pkgconfig
, libdrm, libva, libX11, libXext, libXfixes, wayland, meson, ninja
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "13a0dccphi4cpr2cx45kg4djxsssi3d1fcjrkx27b16xiayp5lx9";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ libdrm libva libX11 libXext libXfixes wayland ];

  mesonFlags = [
    "-Ddrm=true"
    "-Dx11=true"
    "-Dwayland=true"
  ];

  enableParallelBuilding = true;

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
