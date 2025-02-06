{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2024-08-05";

  src = fetchFromGitHub {
    owner = "the1lab";
    repo = pname;
    rev = "7cc9bf7bbe90be5491e0d64da90a36afa29a540b";
    hash = "sha256-hOyf6ZzejDAFDRj6liFZsBc9bKdxV5bzTPP4kGXIhW0=";
  };

  postPatch = ''
    # We don't need anything in support; avoid installing LICENSE.agda
    rm -rf support

    # Remove verbosity options as they make Agda take longer and use more memory.
    shopt -s globstar extglob
    files=(src/**/*.@(agda|lagda.md))
    sed -Ei '/OPTIONS/s/ -v ?[^ #]+//g' "''${files[@]}"

    # Generate all-pages manually instead of building the build script.
    mkdir -p _build
    for f in "''${files[@]}"; do
      f=''${f#src/} f=''${f%%.*} f=''${f//\//.}
      echo "open import $f"
    done > _build/all-pages.agda
  '';

  libraryName = "1lab";
  libraryFile = "1lab.agda-lib";
  everythingFile = "_build/all-pages.agda";

  meta = with lib; {
    description = "A formalised, cross-linked reference resource for mathematics done in Homotopy Type Theory ";
    homepage = src.meta.homepage;
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ncfavier ];
  };
}
