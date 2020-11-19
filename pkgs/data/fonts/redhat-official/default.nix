{ lib, fetchFromGitHub }:
let
  version = "2.3.2";
in
fetchFromGitHub {
  name = "redhat-official-${version}";

  owner = "RedHatOfficial";
  repo = "RedHatFont";
  rev = version;

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype OTF/*.otf
    install -m444 -Dt $out/share/fonts/truetype TTF/*.ttf
  '';

  sha256 = "1afvxmgif61hb17g8inmxvq30vkzwh30mydlqpf0zgvaaz8qdwmv";

  meta = with lib; {
    homepage = "https://github.com/RedHatOfficial/RedHatFont";
    description = "Red Hat's Open Source Fonts - Red Hat Display and Red Hat Text";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
