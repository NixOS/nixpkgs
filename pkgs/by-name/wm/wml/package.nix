{
  cmake,
  fetchFromGitHub,
  lib,
  lynx,
  makeBinaryWrapper,
  ncurses,
  pcre,
  perl,
  perlPackages,
  stdenv,
}:
let
  shlomif-cmake-modules = fetchFromGitHub {
    owner = "shlomif";
    repo = "shlomif-cmake-modules";
    rev = "2fa3e9be1a1df74ad0e10f0264bfa60e1e3a755c";
    hash = "sha256-MNGpegbZRwfD8A3VHVNYrDULauLST3Nt18/3Ht6mpZw=";
  };
  perlDeps = with perlPackages; [
    BitVector
    CarpAlways
    ClassXSAccessor
    FileWhich
    GD
    ImageSize
    ListMoreUtils
    PathTiny
    TermReadKey
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wml";
  version = "2.32.0-unstable-2025-12-23";

  src = fetchFromGitHub {
    owner = "thewml";
    repo = "website-meta-language";
    rev = "de200ecef0b2a64553799b1d83dfa65580d0bc16";
    hash = "sha256-okeDaCX4Pp5qVFfHmaz+keagX6vgzFTtGoiim/pW6IA=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    cmake
    lynx
    makeBinaryWrapper
  ];

  buildInputs = perlDeps ++ [
    ncurses
    pcre
    perl
  ];

  preConfigure = ''
    ln -s ${shlomif-cmake-modules}/shlomif-cmake-modules/Shlomif_Common.cmake cmake/
  '';

  preFixup = ''
    rm $out/bin/wmu

    for f in $(find $out/bin/ -type f -executable); do
      wrapProgram "$f" \
        --set PERL5LIB ${perlPackages.makePerlPath perlDeps}
    done
  '';

  meta = {
    description = "Offline HTML preprocessor";
    homepage = "https://www.shlomifish.org/open-source/projects/website-meta-language/";
    downloadPage = "https://github.com/thewml/website-meta-language/releases";
    changelog = "https://github.com/thewml/website-meta-language/blob/${finalAttrs.src.rev}/src/ChangeLog";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "wml";
    platforms = lib.platforms.linux;
  };
})
