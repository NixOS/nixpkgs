{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  installShellFiles,
  nixosTests,
  asciidoc,
  pkg-config,
  libxslt,
  libxml2,
  docbook_xml_dtd_45,
  docbook_xsl,
  dbus-glib,
  libcap_ng,
  libqb,
  libseccomp,
  polkit,
  protobuf,
  audit,
  libsodium,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.1.4";
  pname = "usbguard";

  src = fetchFromGitHub {
    owner = "USBGuard";
    repo = "usbguard";
    tag = "usbguard-${finalAttrs.version}";
    hash = "sha256-PDuYszdG6BK4fkAHWWBct1d7tnwwe+5XOw+xmSPoPCY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    installShellFiles
    asciidoc
    pkg-config
    libxslt # xsltproc
    libxml2 # xmllint
    docbook_xml_dtd_45
    docbook_xsl
    dbus-glib # gdbus-codegen
    protobuf # protoc
  ];

  buildInputs = [
    dbus-glib
    libcap_ng
    libqb
    libseccomp
    libsodium
    polkit
    protobuf
    audit
  ];

  configureFlags = [
    "--with-bundled-catch"
    "--with-bundled-pegtl"
    "--with-dbus"
    "--with-crypto-library=sodium"
    "--with-polkit"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash --name usbguard.bash scripts/bash_completion/usbguard
    installShellCompletion --zsh --name _usbguard scripts/usbguard-zsh-completion
  '';

  passthru.tests = nixosTests.usbguard;

  meta = {
    description = "Protect your computer against rogue USB devices (a.k.a. BadUSB)";
    longDescription = ''
      USBGuard is a software framework for implementing USB device authorization
      policies (what kind of USB devices are authorized) as well as method of
      use policies (how a USB device may interact with the system). Simply put,
      it is a USB device allowlisting tool.
    '';
    homepage = "https://usbguard.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.tnias ];
  };
})
