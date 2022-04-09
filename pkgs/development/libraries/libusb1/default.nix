{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, enableUdev ? stdenv.isLinux && !stdenv.hostPlatform.isMusl
, udev
, libobjc
, IOKit
, Security
, withStatic ? false
}:

stdenv.mkDerivation rec {
  pname = "libusb";
  version = "1.0.25";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb";
    rev = "v${version}";
    sha256 = "141wygijjcgka0h31504cdlvih4l2j02j67pcbb2l527p7dbc5pn";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  propagatedBuildInputs =
    lib.optional enableUdev udev ++
    lib.optionals stdenv.isDarwin [ libobjc IOKit Security ];

  dontDisableStatic = withStatic;

  configureFlags = lib.optional (!enableUdev) "--disable-udev";

  preFixup = lib.optionalString enableUdev ''
    sed 's,-ludev,-L${lib.getLib udev}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = with lib; {
    homepage = "https://libusb.info/";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
    '';
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ prusnak ];
  };
}
