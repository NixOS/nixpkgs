{ fetchzip, lib }:

let
  version = "3.003";
in
fetchzip {
  name = "sil-padauk-${version}";
  url = "mirror://debian/pool/main/f/fonts-sil-padauk/fonts-sil-padauk_${version}.orig.tar.xz";
  sha256 = "sha256-oK+EufbvsqXunTgcWj+DiNdfpRl+VPO60Wc9KYjZv5A=";

  postFetch = ''
    unpackDir="$TMPDIR/unpack"
    mkdir "$unpackDir"
    cd "$unpackDir"
    tar xf "$downloadedFile" --strip-components=1
    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "Burmese Unicode 6 TrueType font";
    homepage = "https://software.sil.org/padauk";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
