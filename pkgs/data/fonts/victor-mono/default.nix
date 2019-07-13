{ lib, fetchFromGitHub }:

let
  pname = "victor-mono";
  version = "1.2.1";
in fetchFromGitHub {
  name = "${pname}-${version}";

  owner = "rubjo";
  repo = pname;
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    unzip public/VictorMonoAll.zip TTF/\*
    mkdir -p $out/share/fonts/truetype/${pname}
    cp TTF/*.ttf $out/share/fonts/truetype/${pname}
  '';

  sha256 = "0gisjcywmn3kjgwfmzcv8ibxqd126s93id2w0zjly0c7m3ckamh8";

  meta = with lib; {
    homepage = https://rubjo.github.io/victor-mono;
    description = "A free programming font with cursive italics and ligatures";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier ];
    platforms = platforms.all;
  };
}
