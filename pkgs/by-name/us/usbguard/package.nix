{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
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

stdenv.mkDerivation rec {
  version = "1.1.3";
  pname = "usbguard";

  src = fetchFromGitHub {
    owner = "USBGuard";
    repo = pname;
    rev = "usbguard-${version}";
    hash = "sha256-8y8zaKJfoIXc9AvG1wi3EzZA7BR2wVFLuOyD+zpBY0s=";
    fetchSubmodules = true;
  };

  patches = [
    # The patch is taken from upstream's main branch. Drop it for the next release.
    (fetchpatch {
      name = "Adapt-for-protobuf-30.0-API-changes-650.patch";
      url = "https://github.com/USBGuard/usbguard/commit/52e32de1312ba72d92b2f501d3c0485b5d7a5169.patch";
      hash = "sha256-Ywu35a/+gEfeI0korngXtzD0mXK2K1A6ayiGDiEBZg0=";
    })
  ];

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

  meta = with lib; {
    description = "USBGuard software framework helps to protect your computer against BadUSB";
    longDescription = ''
      USBGuard is a software framework for implementing USB device authorization
      policies (what kind of USB devices are authorized) as well as method of
      use policies (how a USB device may interact with the system). Simply put,
      it is a USB device whitelisting tool.
    '';
    homepage = "https://usbguard.github.io/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.tnias ];
  };
}
