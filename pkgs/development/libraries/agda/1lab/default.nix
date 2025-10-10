{
  lib,
  mkDerivation,
  fetchFromGitHub,
}:

mkDerivation {
  pname = "1lab";
  version = "unstable-2025-07-01";

  src = fetchFromGitHub {
    owner = "the1lab";
    repo = "1lab";
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
  '';

  meta = with lib; {
    description = "Formalised, cross-linked reference resource for mathematics done in Homotopy Type Theory ";
    homepage = "https://github.com/the1lab/1lab";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ncfavier ];
  };
}
