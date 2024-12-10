{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  udev,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "media-player-info";
  version = "24";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/media-player-info/${pname}-${version}.tar.gz";
    sha256 = "0d0i7av8v369hzvlynwlrbickv1brlzsmiky80lrjgjh1gdldkz6";
  };

  buildInputs = [
    udev
    systemd
  ];
  nativeBuildInputs = [
    pkg-config
    python3
  ];

  postPatch = ''
    patchShebangs ./tools
  '';

  configureFlags = [ "--with-udevdir=${placeholder "out"}/lib/udev" ];

  meta = with lib; {
    description = "A repository of data files describing media player capabilities";
    homepage = "https://www.freedesktop.org/wiki/Software/media-player-info/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; linux;
  };
}
