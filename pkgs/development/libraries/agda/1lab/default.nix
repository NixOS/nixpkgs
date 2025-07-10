{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2025-07-01";

  src = fetchFromGitHub {
    owner = "the1lab";
    repo = pname;
    rev = "e9c2ad2b3ba9cefad36e72cb9d732117c68ac862";
    hash = "sha256-wKh77+xCdfMtnq9jMlpdnEptGO+/WVNlQFa1TDbdUGs=";
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
