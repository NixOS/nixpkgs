{ stdenv, fetchurl
, pkgconfig
, python3Packages
, wrapGAppsHook
, atk
, dbus
, evemu
, frame
, gdk_pixbuf
, gobject-introspection
, grail
, gtk3
, libX11
, libXext
, libXi
, libXtst
, pango
, xorgserver
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "geis-${version}";
  version = "2.2.17";

  src = fetchurl {
    url = "https://launchpad.net/geis/trunk/${version}/+download/${name}.tar.xz";
    sha256 = "1svhbjibm448ybq6gnjjzj0ak42srhihssafj0w402aj71lgaq4a";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=misleading-indentation" "-Wno-error=pointer-compare" ];

  hardeningDisable = [ "format" ];

  pythonPath = with python3Packages;
    [ pygobject3  ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook python3Packages.wrapPython];
  buildInputs = [ atk dbus evemu frame gdk_pixbuf gobject-introspection grail
    gtk3 libX11 libXext libXi libXtst pango python3Packages.python xorgserver
  ];

  patchPhase = ''
    substituteInPlace python/geis/geis_v2.py --replace \
      "ctypes.util.find_library(\"geis\")" "'$out/lib/libgeis.so'"
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")
  '';

  meta = {
    description = "A library for input gesture recognition";
    homepage = https://launchpad.net/geis;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
