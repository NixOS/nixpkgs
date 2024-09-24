{ lib, stdenv, fetchurl
, pkg-config
, python3Packages
, wrapGAppsHook3
, atk
, dbus
, evemu
, frame
, gdk-pixbuf
, gobject-introspection
, grail
, gtk3
, xorg
, pango
, xorgserver
}:


stdenv.mkDerivation rec {
  pname = "geis";
  version = "2.2.17";

  src = fetchurl {
    url = "https://launchpad.net/geis/trunk/${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "1svhbjibm448ybq6gnjjzj0ak42srhihssafj0w402aj71lgaq4a";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=misleading-indentation -Wno-error=pointer-compare";

  hardeningDisable = [ "format" ];

  pythonPath = with python3Packages;
    [ pygobject3  ];

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 python3Packages.wrapPython gobject-introspection ];
  buildInputs = [ atk dbus evemu frame gdk-pixbuf grail
    gtk3 xorg.libX11 xorg.libXext xorg.libXi xorg.libXtst pango python3Packages.python xorgserver
  ];

  patchPhase = ''
    substituteInPlace python/geis/geis_v2.py --replace \
      "ctypes.util.find_library(\"geis\")" "'$out/lib/libgeis.so'"
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Library for input gesture recognition";
    homepage = "https://launchpad.net/geis";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
