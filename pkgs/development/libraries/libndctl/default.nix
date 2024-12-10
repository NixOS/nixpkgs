{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  asciidoc,
  pkg-config,
  xmlto,
  docbook_xsl,
  docbook_xml_dtd_45,
  libxslt,
  json_c,
  kmod,
  which,
  util-linux,
  udev,
  keyutils,
}:

stdenv.mkDerivation rec {
  pname = "libndctl";
  version = "71.1";

  src = fetchFromGitHub {
    owner = "pmem";
    repo = "ndctl";
    rev = "v${version}";
    sha256 = "sha256-osux3DiKRh8ftHwyfFI+WSFx20+yJsg1nVx5nuoKJu4=";
  };

  outputs = [
    "out"
    "lib"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    asciidoc
    pkg-config
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
    which
  ];

  buildInputs = [
    json_c
    kmod
    util-linux
    udev
    keyutils
  ];

  configureFlags = [
    "--without-bash"
    "--without-systemd"
    "--disable-asciidoctor" # depends on ruby 2.7, use asciidoc instead
  ];

  patchPhase = ''
    patchShebangs test

    substituteInPlace git-version --replace /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace /bin/sh ${stdenv.shell}

    echo "m4_define([GIT_VERSION], [${version}])" > version.m4;
  '';

  meta = with lib; {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage = "https://github.com/pmem/ndctl";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.linux;
  };
}
