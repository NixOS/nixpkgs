{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xosview2";
  version = "2.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/xosview/xosview2-${finalAttrs.version}.tar.gz";
    hash = "sha256-tNBZdhCy8jpbTA19T8hxCO2c+wxy03EJ9ar3GAjOpcU=";
  };

  outputs = [
    "out"
    "man"
  ];

  buildInputs = [ libX11 ];

  meta = {
    homepage = "https://xosview.sourceforge.net/index.html";
    description = "Lightweight graphical operating system monitor";
    longDescription = ''
      xosview is a lightweight program that gathers information from your
      operating system and displays it in graphical form. It attempts to show
      you in a quick glance an overview of how your system resources are being
      utilized.

      It can be configured to be nothing more than a small strip showing a
      couple of parameters on a desktop task bar. Or it can display dozens of
      meters and rolling graphical charts over your entire screen.

      Since xosview renders all graphics with core X11 drawing methods, you can
      run it on one machine and display it on another. This works even if your
      other host is an operating system not running an X server inside a
      virtual machine running on a physically different host. If you can
      connect to it on a network, then you can popup an xosview instance and
      monitor what is going on.
    '';
    license = with lib.licenses; [
      gpl2
      bsdOriginal
    ];
    mainProgram = "xosview2";
    maintainers = with lib.maintainers; [ ];
    inherit (libX11.meta) platforms;
  };
})
