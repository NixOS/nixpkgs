{ stdenv, fetchFromGitHub, cargo, rustc, autoreconfHook, jdk, glib, xulrunner, zip, pkgconfig, npapi_sdk, bash, bc }:

stdenv.mkDerivation rec {
  pname = "adoptopenjdk-icedtea-web";

  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "AdoptOpenJDK";
    repo = "IcedTea-Web";
    rev = "icedtea-web-${version}";
    sha256 = "0pxijw9v5k4j840jczglx9qyfd57df390g5jdaz3qafblfg0k10n";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig bc ];
  buildInputs = [ cargo rustc glib xulrunner zip npapi_sdk ];

  preConfigure = ''
    configureFlagsArray+=("BIN_BASH=${bash}/bin/bash")
  '';

  patches = [ ./patches/0001-make-cargo-work-with-nix-build-on-linux.patch ];

  doCheck = true;
  preCheck = ''
    # Needed for the below rust-launcher tests to pass
    # dirs_paths_helper::tests::check_config_files_paths
    # dirs_paths_helper::tests::check_legacy_config_files_paths

    mkdir -p $HOME/.icedtea
    touch $HOME/.icedtea/deployment.properties

    mkdir -p $XDG_CONFIG_HOME/icedtea-web
    touch $XDG_CONFIG_HOME/icedtea-web/deployment.properties
  '';

  HOME = "/build";
  XDG_CONFIG_HOME = "/build";

  configureFlags = [
    "--with-itw-libs=DISTRIBUTION"
    "--with-jdk-home=${jdk.home}"
    "--disable-docs"
  ];

  mozillaPlugin = "/lib";

  postInstall = ''
    mkdir -p $out/share/applications
    cp javaws.desktop itweb-settings.desktop policyeditor.desktop $out/share/applications
  '';

  meta = {
    description = "Java web browser plugin and an implementation of Java Web Start";
    longDescription = ''
      A Free Software web browser plugin running applets written in the Java
      programming language and an implementation of Java Web Start, originally
      based on the NetX project.
    '';
    homepage = "https://github.com/adoptopenjdk/icedtea-web";
    platforms = stdenv.lib.platforms.linux;
  };
}
