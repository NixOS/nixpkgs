{ lib
, stdenv
, fetchFromGitHub
<<<<<<< HEAD
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
=======
, autoreconfHook
, docbook-xsl-nons
, gtk-doc
, installShellFiles
, libxslt # for xsltproc
, pkg-config
, which
, libffi
, libiconv
, libintl
, libtasn1
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "p11-kit";
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.24.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-paLiRYgYshuedgDgW2nEsv4/Loq6qFyQMjfBJwqtHzw=";
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
=======
    hash = "sha256-1QIMEGBZsqLYU3v5ZswD5K9VcIGLBovJlC10lBHhH7c=";
  };

  outputs = [ "out" "bin" "dev"];

  # For cross platform builds of p11-kit, libtasn1 in nativeBuildInputs
  # provides the asn1Parser binary on the hostPlatform needed for building.
  # at the same time, libtasn1 in buildInputs provides the libasn1 library
  # to link against for the target platform.
  # Hence, libtasn1 is required in both native and build inputs.
  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-nons
    gtk-doc
    installShellFiles
    libtasn1
    libxslt.bin
    pkg-config
    which
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    libffi
<<<<<<< HEAD
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
=======
    libiconv
    libintl
    libtasn1
  ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--enable-doc"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-trust-paths=${lib.concatStringsSep ":" [
      "/etc/ssl/trust-source"                  # p11-kit trust source
      "/etc/ssl/certs/ca-certificates.crt"     # NixOS + Debian/Ubuntu/Arch/Gentoo...
      "/etc/pki/tls/certs/ca-bundle.crt"       # Fedora/CentOS
      "/var/lib/ca-certificates/ca-bundle.pem" # openSUSE
      "/etc/ssl/cert.pem"                      # Darwin/macOS
    ]}"
  ];

  enableParallelBuilding = true;

  # Tests run in fakeroot for non-root users
  preCheck = ''
    if [ "$(id -u)" != "0" ]; then
      export FAKED_MODE=1
    fi
  '';

  doCheck = !stdenv.isDarwin;

  installFlags = [
    "exampledir=${placeholder "out"}/etc/pkcs11"
  ];

  postInstall = ''
    installShellCompletion --bash bash-completion/{p11-kit,trust}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
