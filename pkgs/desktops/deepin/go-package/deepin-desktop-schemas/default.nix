{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
, go-lib
, glib
}:
buildGoPackage rec {
  pname = "deepin-desktop-schemas";
  version = "5.10.11";

  goPackagePath = "github.com/linuxdeepin/deepin-desktop-schemas";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-MboNj0zC3azavDUsmeNNafCcUa0GeoySl610+WOtNww=";
  };

  nativeBuildInputs = [ glib ];
  buildInputs = [ go-lib ];

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
    addToSearchPath GOPATH "${go-lib}/share/gocode"
    make ARCH=${stdenv.targetPlatform.linuxArch} -C go/src/${goPackagePath}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/" -C go/src/${goPackagePath}
    runHook postInstall
  '';

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  meta = with lib; {
    description = "GSettings deepin desktop-wide schemas";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-schemas";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
