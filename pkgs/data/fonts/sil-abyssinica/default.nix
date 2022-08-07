{ fetchzip, lib }:

let
  version = "1.500";
in
fetchzip {
  name = "sil-abyssinica-${version}";
  url = "mirror://debian/pool/main/f/fonts-sil-abyssinica/fonts-sil-abyssinica_${version}.orig.tar.xz";
  sha256 = "sha256-fCa88wG2JfHTaHaBkuvoncbcbrh3XNzc8ewS3W+W/fM=";

  postFetch = ''
    mkdir -p $out/share/fonts
    tar xf $downloadedFile --strip-components=1 -C $out/share/fonts AbyssinicaSIL-${version}/AbyssinicaSIL-R.ttf
  '';

  meta = with lib; {
    description = "Unicode font for Ethiopian and Erythrean scripts (Amharic et al.)";
    homepage = "https://software.sil.org/abyssinica/";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
