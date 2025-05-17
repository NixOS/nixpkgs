{
  lib,
  stdenv,
  fetchFromGitHub,
  capstone,
  libbfd,
  libelf,
  libiberty,
  readline,
}:

stdenv.mkDerivation {
  pname = "wcc";
  version = "0.0.7-unstable-2025-04-30";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    rev = "8cbb49345d9596dfd37bd1b681753aacaab96475";
    hash = "sha256-TYYtnMlrp/wbrTmwd3n90Uni7WE54gK6zKSBg4X9ZfA=";
    deepClone = true;
    fetchSubmodules = true;
  };

  buildInputs = [
    capstone
    libbfd
    libelf
    libiberty
    readline
  ];

  postPatch = ''
    sed -i src/wsh/include/libwitch/wsh.h src/wsh/scripts/INDEX \
      -e "s#/usr/share/wcc#$out/share/wcc#"

    sed -i -e '/stropts.h>/d' src/wsh/include/libwitch/wsh.h

    sed -i '/wsh-`uname -m`.*-static/d' src/wsh/Makefile
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  installFlags = [ "DESTDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/usr/bin $out/lib/x86_64-linux-gnu
  '';

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
    mkdir -p $out/share/man/man1
    cp doc/manpages/*.1 $out/share/man/man1/
  '';

  postFixup = ''
    # not detected by patchShebangs
    substituteInPlace $out/bin/wcch --replace-fail '#!/usr/bin/wsh' "#!$out/bin/wsh"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/endrazine/wcc";
    description = "Witchcraft compiler collection: tools to convert and script ELF files";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      orivej
      DieracDelta
    ];
  };
}
