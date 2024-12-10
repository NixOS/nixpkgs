{
  lib,
  stdenv,
  fetchurl,
  lv2,
  meson,
  ninja,
  pkg-config,
  serd,
  sord,
  writeScript,
}:

stdenv.mkDerivation rec {
  pname = "sratom";
  version = "0.6.16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-ccFXmRGD5T0FVTk7tCccdcm19dq3Sl7yLyCLsi3jIsQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    lv2
    serd
    sord
  ];

  postPatch = ''
    patchShebangs --build scripts/dox_to_sphinx.py
  '';

  mesonFlags = [
    "-Ddocs=disabled"
  ];

  passthru = {
    updateScript = writeScript "update-sratom" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of 'download.drobilla.net/sratom-0.30.16.tar.xz">'
      new_version="$(curl -s https://drobilla.net/category/sratom/ |
          pcregrep -o1 'download.drobilla.net/sratom-([0-9.]+).tar.xz' |
          head -n1)"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    homepage = "https://drobilla.net/software/sratom";
    description = "A library for serialising LV2 atoms to/from RDF";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
