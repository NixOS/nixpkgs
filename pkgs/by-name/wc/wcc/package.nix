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
  pname = "wcc-unstable";
  version = "0.0.7-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    rev = "fe1f71d7f6c756e196b82a884dc38bb8f8aef4d3";
    sha256 = "sha256-Kb9QIL+W0JFdfweqZL05OajXGGqXn6e6Jv3IVCr3BwQ=";
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
  '';

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
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
