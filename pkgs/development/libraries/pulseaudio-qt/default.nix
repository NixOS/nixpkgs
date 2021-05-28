{ mkDerivation
, lib
, fetchurl
, cmake
, extra-cmake-modules
, pkg-config
, pulseaudio
}:

mkDerivation rec {
  pname = "pulseaudio-qt";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${lib.versions.majorMinor version}.tar.xz";
    sha256 = "1i0ql68kxv9jxs24rsd3s7jhjid3f2fq56fj4wbp16zb4wd14099";
  };

  buildInputs = [
    pulseaudio
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "Pulseaudio bindings for Qt";
    homepage    = "https://invent.kde.org/libraries/pulseaudio-qt";
    license     = with licenses; [ lgpl2 ];
    maintainers = with maintainers; [ doronbehar ];
  };
}
