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
  version = "2.32.0";

  src = fetchFromGitHub {
    owner = "thewml";
    repo = "website-meta-language";
    tag = "releases/wml-${finalAttrs.version}";
    hash = "sha256-9ZiMGm0W2qS/7nL8NsmGBsuB5sNJvWuJaxE7CTdWo6s=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  # https://github.com/thewml/website-meta-language/commit/727806494dcb9d334ffb324aedbf6076e4796299
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'CMAKE_MINIMUM_REQUIRED(VERSION 3.0)' 'CMAKE_MINIMUM_REQUIRED(VERSION 3.15)'
  '';

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
    changelog = "https://github.com/thewml/website-meta-language/blob/${finalAttrs.src.tag}/src/ChangeLog";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "wml";
    platforms = lib.platforms.linux;
  };
})
