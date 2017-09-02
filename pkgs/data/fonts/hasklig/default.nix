{stdenv, fetchzip}:

let
  version = "1.1";
in fetchzip {
  name = "hasklig-${version}";

  url = "https://github.com/i-tu/Hasklig/releases/download/${version}/Hasklig-${version}.zip";

  postFetch = ''
    unzip $downloadedFile
    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype
  '';

  sha256 = "0xxyx0nkapviqaqmf3b610nq17k20afirvc72l32pfspsbxz8ybq";

  meta = with stdenv.lib; {
    homepage = https://github.com/i-tu/Hasklig;
    description = "A font with ligatures for Haskell code based off Source Code Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ davidrusu profpatsch ];
  };
}
