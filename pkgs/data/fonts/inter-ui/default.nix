{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  version = "2.5";
  name = "inter-ui-${version}";

  src = fetchzip {
    url = "https://github.com/rsms/inter/releases/download/v${version}/Inter-UI-${version}.zip";
    sha256 = "0m81n89s3miaxfbaa2v2hklffq4kk37kg9rrmb9yjy4zjxqyli1f";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp 'Inter UI (OTF)'/*.otf $out/share/fonts/opentype
  '';

  meta = with stdenv.lib; {
    homepage = https://rsms.me/inter/;
    description = "A typeface specially designed for user interfaces";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ demize ];
  };
}
