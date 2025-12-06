{
  autoPatchelfHook,
  dpkg,
  fetchurl,
  gtk3,
  gtksourceview3,
  krb5,
  lib,
  libgee,
  libsecret,
  libxkbcommon,
  stdenv,
  wrapGAppsHook3,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tableplus";
  version = "0.1.266";

  src = fetchurl {
    url = "https://deb.tableplus.com/debian/22/pool/main/t/tableplus/tableplus_${finalAttrs.version}_amd64.deb";
    hash = "sha256-AxIeSsIDVDvSrbNckaLwu/Lu/EqK+DO/yZKIPqKYD7Y=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtksourceview3
    krb5
    libgee
    libsecret
    libxkbcommon
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt/tableplus $out/
    ln -s $out/tableplus/tableplus $out/bin/tableplus

    runHook postInstall
  '';

  meta = with lib; {
    description = "Database management made easy";
    homepage = "https://tableplus.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ rhydianjenkins ];
    platforms = platforms.linux;
  };
})
