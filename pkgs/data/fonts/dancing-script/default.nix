{ lib, fetchFromGitHub }:

let
  pname = "dancing-script";
  version = "2.0";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "impallari";
  repo = "DancingScript";
  rev = "f7f54bc1b8836601dae8696666bfacd306f77e34";
  sha256 = "dfFvh8h+oMhAQL9XKMrNr07VUkdQdxAsA8+q27KWWCA=";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/truetype fonts/ttf/*.ttf
  '';

  meta = with lib; {
    description = "Dancing Script";
    longDescription = "A lively casual script where the letters bounce and change size slightly.";
    homepage = "https://github.com/impallari/DancingScript";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ wdavidw ];
  };
}
