{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, enableUdev ? stdenv.isLinux && !stdenv.hostPlatform.isMusl
, udev
, libobjc
, IOKit
, withStatic ? false
}:

stdenv.mkDerivation rec {
  pname = "libusb";
  version = "1.0.24";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "libusb";
    rev = "v${version}";
    sha256 = "18ri8ky422hw64zry7bpbarb1m0hiljyf64a0a9y093y7aad38i7";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  propagatedBuildInputs =
    lib.optional enableUdev udev ++
    lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  dontDisableStatic = withStatic;

  configureFlags = lib.optional (!enableUdev) "--disable-udev";

  preFixup = lib.optionalString enableUdev ''
    sed 's,-ludev,-L${lib.getLib udev}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = with lib; {
    homepage = "https://libusb.info/";
    repositories.git = "https://github.com/libusb/libusb";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
    '';
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ prusnak ];
  };
}
