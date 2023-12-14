{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libtasn1
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, gettext
, mesonEmulatorHook
, libffi
, libintl
}:

stdenv.mkDerivation rec {
  pname = "p11-kit";
  version = "0.25.3";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = pname;
    rev = version;
    hash = "sha256-zIbkw0pwt4TdyjncnSDeTN6Gsx7cc+x7Un4rnagZxQk=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "bin" "dev" ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libtasn1 # asn1Parser
    libxslt # xsltproc
    docbook-xsl-nons
    docbook_xml_dtd_43
    gettext
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    libffi
    libtasn1
    libintl
  ];

  mesonFlags = [
    "--sysconfdir=/etc"
    (lib.mesonBool "man" true)
    (lib.mesonEnable "systemd" false)
    (lib.mesonOption "bashcompdir" "${placeholder "bin"}/share/bash-completion/completions")
    (lib.mesonOption "trust_paths" (lib.concatStringsSep ":" [
      "/etc/ssl/trust-source" # p11-kit trust source
      "/etc/ssl/certs/ca-certificates.crt" # NixOS + Debian/Ubuntu/Arch/Gentoo...
      "/etc/pki/tls/certs/ca-bundle.crt" # Fedora/CentOS
      "/var/lib/ca-certificates/ca-bundle.pem" # openSUSE
      "/etc/ssl/cert.pem" # Darwin/macOS
    ]))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postPatch = ''
    # Install sample config files to $out/etc even though they will be loaded from /etc.
    substituteInPlace p11-kit/meson.build \
      --replace 'install_dir: prefix / p11_system_config' "install_dir: '$out/etc/pkcs11'"
  '';

  meta = with lib; {
    description = "Library for loading and sharing PKCS#11 modules";
    longDescription = ''
      Provides a way to load and enumerate PKCS#11 modules.
      Provides a standard configuration setup for installing
      PKCS#11 modules in such a way that they're discoverable.
    '';
    homepage = "https://p11-glue.github.io/p11-glue/p11-kit.html";
    changelog = [
      "https://github.com/p11-glue/p11-kit/raw/${version}/NEWS"
      "https://github.com/p11-glue/p11-kit/releases/tag/${version}"
    ];
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
