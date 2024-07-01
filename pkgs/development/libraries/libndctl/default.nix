{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, asciidoctor
, iniparser
, json_c
, keyutils
, kmod
, udev
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "libndctl";
  version = "79";

  src = fetchFromGitHub {
    owner  = "pmem";
    repo   = "ndctl";
    rev    = "v${version}";
    sha256 = "sha256-gG1Rz5AtDLzikGFr8A3l25ypd+VoLw2oWjszy9ogDLk=";
  };

  outputs = [ "out" "man" "dev" ];

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
    ];

  buildInputs =
    [
      asciidoctor
      iniparser
      json_c
      keyutils
      kmod
      udev
      util-linux
    ];

  mesonFlags =
    [
      "-Drootprefix=${placeholder "out"}"
      "-Dsysconfdir=${placeholder "out"}/etc/ndctl.conf.d"
      "-Dlibtracefs=disabled"
      # Use asciidoctor due to xmlto errors
      "-Dasciidoctor=enabled"
      "-Dsystemd=disabled"
      "-Diniparserdir=${iniparser}"
    ];

  patchPhase = ''
    patchShebangs test

    substituteInPlace git-version --replace /bin/bash ${stdenv.shell}
    substituteInPlace git-version-gen --replace /bin/sh ${stdenv.shell}
  '';

  meta = with lib; {
    description = "Tools for managing the Linux Non-Volatile Memory Device sub-system";
    homepage    = "https://github.com/pmem/ndctl";
    license     = licenses.lgpl21;
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
  };
}
