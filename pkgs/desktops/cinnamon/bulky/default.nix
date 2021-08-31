{ stdenv
, lib
, fetchFromGitHub
, wrapGAppsHook
, python3
, gsettings-desktop-schemas
, gettext
, gtk3
, glib
, common-licenses
}:

stdenv.mkDerivation rec {
  pname = "bulky";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "bulky";
    rev = version;
    sha256 = "sha256-+3OoeuGuyiHWlUrxm5A7CmNR+ijxdlmecmvqk+i+h08=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gsettings-desktop-schemas
    gettext
  ];

  buildInputs = [
    (python3.withPackages(p: with p; [ pygobject3 magic setproctitle ]))
    gsettings-desktop-schemas
    gtk3
    glib
  ];

  postPatch = ''
    substituteInPlace usr/lib/bulky/bulky.py \
                     --replace "/usr/share/locale" "$out/share/locale" \
                     --replace /usr/share/bulky "$out/share/bulky" \
                     --replace /usr/share/common-licenses "${common-licenses}/share/common-licenses" \
                     --replace __DEB_VERSION__  "${version}"
  '';

  installPhase = ''
    runHook preInstall
    chmod +x usr/share/applications/*
    cp -ra usr $out
    ln -sf $out/lib/bulky/bulky.py $out/bin/bulky
    runHook postInstall
  '';

  meta = with lib; {
    description = "Bulk rename app";
    homepage = "https://github.com/linuxmint/bulky";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
