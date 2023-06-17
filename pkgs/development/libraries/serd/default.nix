{ lib
, stdenv
, fetchurl
, doxygen
, mandoc
, meson
, ninja
, pkg-config
, python3
, sphinx
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "serd";
  version = "0.30.16";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.xz";
    hash = "sha256-9Q9IbaUZzdjQOyDJ5CQU5FkTP1okRBHY5jyu+NmskUY=";
  };

  nativeBuildInputs = [
    doxygen
    mandoc
    meson
    ninja
    pkg-config
    python3
    sphinx
  ];

  postPatch = ''
    patchShebangs .
  '';

  passthru = {
    updateScript = writeScript "update-poke" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of 'download.drobilla.net/serd-0.30.16.tar.xz">'
      new_version="$(curl -s https://drobilla.net/category/serd/ |
          pcregrep -o1 'download.drobilla.net/serd-([0-9.]+).tar.xz' |
          head -n1)"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = with lib; {
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    homepage = "https://drobilla.net/software/serd";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    mainProgram = "serdi";
    platforms = platforms.unix;
  };
}
