{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  libx11,
  libxext,
  libxft,
  libxmu,
  libxrender,
  freetype,
  fontconfig,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "x11perf";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://xorg/individual/test/x11perf-${finalAttrs.version}.tar.xz";
    hash = "sha256-JPgNhLDpYXGpmJMv8Adpj9F3bamXXtQuUdV7nPypGCg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    libx11
    libxext
    libxft
    libxmu
    libxrender
    freetype
    fontconfig
  ];

  postInstall = ''
    substituteInPlace $out/bin/x11perfcomp \
      --replace-fail "/bin/cat" "cat"
  '';

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/test/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
  };

  meta = {
    description = "X11 server performance test program";
    homepage = "https://gitlab.freedesktop.org/xorg/test/x11perf";
    license = lib.licenses.hpnd;
    mainProgram = "x11perf";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
