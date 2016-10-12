{ stdenv, fetchurl, unzip }:

let apk = fetchurl {
            url = "http://www.apkmirror.com/wp-content/themes/APKMirror/download.php?id=60658";
            sha256 = "462e9da7d6eb7cf67aa8abb6f66b522104fa1d7465a10f338ca488a187387490";
          };
in stdenv.mkDerivation rec {
  name = "bookerly-${version}";
  version = "4.21.0.65";

  buildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  unpackPhase = ''
    unzip ${apk}
    sourceRoot=.
  '';

  installPhase = ''
    install -Dm644 -t $out/share/fonts/truetype assets/Bookerly*.ttf
  '';

  meta = with stdenv.lib; {
    homepage = "https://play.google.com/store/apps/details?id=com.amazon.kindle";
    description = "Amazon Kindle fonts";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
