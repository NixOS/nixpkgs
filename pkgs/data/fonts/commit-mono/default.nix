{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "commit-mono";
  version = "1.134";

  src = fetchzip {
    url = "https://github.com/eigilnikolajsen/commit-mono/releases/download/${version}/CommitMono-${version}.zip";
    sha256 = "sha256-uOw5xwbLYYVDRfbzMwNn2xNYOOQ7Mqu8xRlsg4pArSs=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;
  dontFixup = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    runHook postInstall
  '';

  meta = with lib; {
    description = "An anonymous and neutral programming typeface focused on creating a better reading experience";
    homepage = "https://commitmono.com/";
    changelog = "https://github.com/eigilnikolajsen/commit-mono/releases/tag/${version}";
    license = licenses.ofl;
    maintainers = [ maintainers.yoavlavi ];
    platforms = platforms.all;
  };
}
