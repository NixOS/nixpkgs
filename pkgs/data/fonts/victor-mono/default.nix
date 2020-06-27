{ lib, mkFont, fetchFromGitHub, unzip }:

mkFont rec {
  pname = "victor-mono";
  version = "1.3.1";

  src = fetchFromGitHub rec {
    owner = "rubjo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xfqf2i1z86vd2b2jm5v2nz4amyyl95vlc1s1lc9y00am193pc88";

    # Upstream prefers we download from the website,
    # but we really insist on a more versioned resource.
    # Happily, tagged releases on github contain the same
    # file `VictorMonoAll.zip` as from the website,
    # so we extract it from the tagged release.
    # Both methods produce the same file, but this way
    # we can safely reason about what version it is.
    name = "VictorMonoAll.zip";
    postFetch = ''
      tar xvf $downloadedFile --strip-components=2 ${pname}-${version}/public/VictorMonoAll.zip
      mv VictorMonoAll.zip $out
    '';
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  meta = with lib; {
    description = "Free programming font with cursive italics and ligatures";
    homepage = "https://rubjo.github.io/victor-mono";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ jpotier dtzWill ];
    platforms = platforms.all;
  };
}

