{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "vendor-reset-udev-rules";
  version = "0.1.0";

  udevRules = fetchurl {
    url = "https://raw.githubusercontent.com/gnif/vendor-reset/refs/heads/master/udev/99-vendor-reset.rules";
    hash = "sha256-uwV640EdOTjkidjgqKQmKkgD2z31JxhZCoeeZTcLqok=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${udevRules} 99-vendor-reset.rules
    mkdir -p $out/lib/udev/rules.d
    cp 99-vendor-reset.rules $out/lib/udev/rules.d/99-vendor-reset.rules
  '';

  meta = with lib; {
    homepage = "https://github.com/gnif/vendor-reset";
    description = "Rules to ensure vendor-reset is loaded and the reset_method for our devices is set to 'device_specific' for kernel 5.15+";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ vonixxx ];
  };
}
