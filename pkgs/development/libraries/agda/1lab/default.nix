{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation rec {
  pname = "1lab";
  version = "unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "plt-amy";
    repo = pname;
    rev = "d698f21793c4815082c94d174b9eafae912abb1a";
    hash = "sha256-v8avF9zNNz32kLuAacPdEVeUI9rjn6JCiWPzkXfzBS0=";
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
