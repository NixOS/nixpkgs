{ fetchzip, lib }:

let
  version = "00303.01";
in
fetchzip {
  name = "takao-${version}";
  url = "mirror://ubuntu/pool/universe/f/fonts-takao/fonts-takao_${version}.orig.tar.gz";
  sha256 = "sha256-TlPq3iIv8vHlxYu5dkX/Lf6ediYKQaQ5uMbFvypQM/w=";

  postFetch = ''
    unpackDir="$TMPDIR/unpack"
    mkdir "$unpackDir"
    cd "$unpackDir"
    tar xf "$downloadedFile" --strip-components=1
    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "Japanese TrueType Gothic, P Gothic, Mincho, P Mincho fonts";
    homepage = "https://launchpad.net/takao-fonts";
    license = licenses.ipa;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
