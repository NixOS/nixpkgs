{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  glib,
}:

buildGoModule rec {
  pname = "deepin-desktop-schemas";
  version = "6.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-Zp80Yz0qkFAwpQJPgs/gcfCG2DMtvpKdVKRlqOTmaCk=";
  };

  vendorHash = "sha256-q6ugetchJLv2JjZ9+nevUI0ptizh2V+6SByoY/eFJJQ=";

  postPatch = ''
    # Relocate files path for backgrounds and wallpapers
    for file in $(grep -rl "/usr/share")
    do
      substituteInPlace $file \
        --replace-fail "/usr/share" "/run/current-system/sw/share"
    done
  '';

  buildPhase = ''
    runHook preBuild
    make ARCH=${stdenv.hostPlatform.linuxArch}
    runHook postBuild
  '';

  nativeCheckInputs = [ glib ];
  checkPhase = ''
    runHook preCheck
    make test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/"
    runHook postInstall
  '';

  meta = {
    description = "GSettings deepin desktop-wide schemas";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-schemas";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
