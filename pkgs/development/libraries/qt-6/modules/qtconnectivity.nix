{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  bluez,
  pcsclite,
  pkg-config,
}:

qtModule {
  pname = "qtconnectivity";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcsclite ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bluez ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
  ];

  postPatch = ''
    substituteInPlace src/nfc/configure.cmake --replace-fail "qt_configure_add_summary_entry(ARGS pcslite)" "qt_configure_add_summary_entry(ARGS pcsclite)"
  '';
}
