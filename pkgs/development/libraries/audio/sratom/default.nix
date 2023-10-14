{ lib
, stdenv
, fetchurl
, lv2
, meson
, ninja
, pkg-config
, serd
, sord
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "sratom";
  version = "0.6.14";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-mYL69A24Ou3Zs4UOSZ/s1oUri0um3t5RQBNlXP+soeY=";
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

  postFixup = ''
    # remove once updated to 0.6.15 or above
    for f in $dev/lib/pkgconfig/*; do
      echo "Requires: lv2 >=  1.18.4, serd-0 >=  0.30.10, sord-0 >=  0.16.10" >> "$f"
    done
  '';

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
