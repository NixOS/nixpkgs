{ stdenvNoCC, lib, fetchurl }:

let
  version = "3.0";
  relArtifact = name: hash: fetchurl {
    inherit name hash;
    url = "https://github.com/IdreesInc/Monocraft/releases/download/v${version}/${name}";
  };
in
stdenvNoCC.mkDerivation {
  pname = "monocraft";
  inherit version;

  srcs = [
    (relArtifact "Monocraft.otf" "sha256-PA1W+gOUStGw7cDmtEbG+B6M+sAYr8cft+Ckxj5LciU=")
    (relArtifact "Monocraft.ttf" "sha256-S4j5v2bTJbhujT3Bt8daNN1YGYYP8zVPf9XXjuR64+o=")
    (relArtifact "Monocraft-no-ligatures.ttf" "sha256-MuHfoP+dsXe+ODN4vWFIj50jwOxYyIiS0dd1tzVxHts=")
    (relArtifact "Monocraft-nerd-fonts-patched.ttf" "sha256-QxMp8UwcRjWySNHWoNeX2sX9teZ4+tCFj+DG41azsXw=")
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    find $srcs -name '*.otf' -exec install -Dm644 --target $out/share/fonts/opentype {} +
    find $srcs -name '*.ttf' -exec install -Dm644 --target $out/share/fonts/truetype {} +
    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming font based on the typeface used in Minecraft";
    homepage = "https://github.com/IdreesInc/Monocraft";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
