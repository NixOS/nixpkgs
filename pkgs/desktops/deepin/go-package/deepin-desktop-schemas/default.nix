{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, glib
}:

buildGoModule rec {
  pname = "deepin-desktop-schemas";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-lvAY0CJ+EohMK16fwIkB7Jq7gTpMhDimPYs9b/IklA4=";
  };

  vendorHash = "sha256-q6ugetchJLv2JjZ9+nevUI0ptizh2V+6SByoY/eFJJQ=";

  postPatch = ''
    # Relocate files path for backgrounds and wallpapers
    for file in $(grep -rl "/usr/share")
    do
      substituteInPlace $file \
        --replace "/usr/share" "/run/current-system/sw/share"
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

  meta = with lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-schemas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
