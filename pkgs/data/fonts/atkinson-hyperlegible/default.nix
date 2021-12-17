{ lib, fetchFromGitHub }:

let
  pname = "atkinson-hyperlegible";
  version = "unstable-2021-04-29";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "googlefonts";
  repo = "atkinson-hyperlegible";
  rev = "1cb311624b2ddf88e9e37873999d165a8cd28b46";
  sha256 = "sha256-urSTqC3rfDRM8IMG+edwKEe7NPiTuDZph3heGHzLDks=";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm644 -t $out/share/fonts/opentype fonts/otf/*
  '';

  meta = with lib; {
    description = "Typeface designed to offer greater legibility and readability for low vision readers";
    homepage = "https://brailleinstitute.org/freefont";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
