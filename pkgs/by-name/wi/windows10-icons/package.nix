{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "windows10-icons";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "B00merang-Artwork";
    repo = "Windows-10";
    rev = "${finalAttrs.version}";
    hash = "sha256-Yz6a7FcgPfzz4w8cKp8oq7/usIBUUZV7qhVmDewmzrI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/windows10
    find . \
      ! -path ./README.md \
      -mindepth 1 -maxdepth 1 \
      -exec cp -r {} $out/share/icons/windows10 \;

    runHook postInstall
  '';

  dontConfigure = true;
  dontBuild = true;

  meta = with lib; {
    description = "Windows 10 icon theme";
    homepage = "http://b00merang.weebly.com/windows-10.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ mib ];
    platforms = platforms.linux;
  };
})
