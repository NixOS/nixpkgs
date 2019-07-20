{ lib, fetchFromGitHub }:

let
  pname = "victor-mono";
  version = "1.2.1";
in fetchFromGitHub rec {
  name = "${pname}-${version}";

  owner = "rubjo";
  repo = pname;
  rev = "v${version}";

  # Upstream prefers we download from the website,
  # but we really insist on a more versioned resource.
  # Happily, tagged releases on github contain the same
  # file `VictorMonoAll.zip` as from the website,
  # so we extract it from the tagged release.
  # Both methods produce the same file, but this way
  # we can safely reason about what version it is.
  postFetch = ''
    tar xvf $downloadedFile --strip-components=2 ${name}/public/VictorMonoAll.zip

    mkdir -p $out/share/fonts/{true,open}type/${pname}

    unzip -j VictorMonoAll.zip \*.ttf -d $out/share/fonts/truetype/${pname}
    unzip -j VictorMonoAll.zip \*.otf -d $out/share/fonts/opentype/${pname}
  '';

  sha256 = "0347n3kdyrbg42rxcgnyghi21qz5iz6w30v7ms2vjal7pfm6h2vn";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}

