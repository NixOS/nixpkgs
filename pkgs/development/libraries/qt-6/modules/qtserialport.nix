{ qtModule
, stdenv
, lib
, qtbase
, systemd
, pkg-config
}:

qtModule {
  pname = "qtserialport";
  qtInputs = [ qtbase ];
  nativeBuildInputs = [ pkg-config ]; # find systemd = udev
  propagatedBuildInputs = [ systemd ]; # TODO buildInputs?

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isLinux "-DNIXPKGS_LIBUDEV=\"${lib.getLib systemd}/lib/libudev\"";
}
