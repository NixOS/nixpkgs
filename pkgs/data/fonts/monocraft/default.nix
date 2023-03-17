{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "monocraft";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "IdreesInc";
    repo = "Monocraft";
    rev = "v${version}";
    sha256 = "sha256-YF0uPCc+dajJtG6mh/JpoSr6GirAhif5L5sp6hFmKLE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype *.otf
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
