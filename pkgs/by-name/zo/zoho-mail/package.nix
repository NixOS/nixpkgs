{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, dpkg
, ffmpeg_5-full
, glib
, gtk3
, wrapGAppsHook
, nss
, xdg-utils
, nspr
, mesa
, systemd
, libglvnd
, libGL
, libGLU
}:
stdenv.mkDerivation rec  {
  pname = "zoho-mail";
  version = "1.6.1";

  src = fetchurl {
    url = "https://downloads.zohocdn.com/zmail-desktop/linux/zoho-mail-desktop-lite-installer-x64-v${version}.deb";
    hash = "sha256-+c5RyymxeL0vppQpA+zceIlQ8336TLhmFgdgINTAQaY=";
  };

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook ];

	dontWrapGApps = true;

  buildInputs = [
    dpkg
    ffmpeg_5-full
    glib
    gtk3
    nss
    xdg-utils
    nspr
    mesa
    libglvnd
    libGL
    libGLU
	];


	runtimeDependencies = buildInputs ++ [systemd];

	dontUnpack = true;

  installPhase = ''
    runHook preInstall

		mkdir -p $out/bin/
		dpkg -x $src $out/bin/
    cd $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "CAD for artists";
    homepage = "https://www.plasticity.xyz";
    # license = licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ imadnyc ];
    platforms = [ "x86_64-linux" ];
  };
}

