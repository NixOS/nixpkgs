{ fetchzip, lib }:

let
  version = "5.0";
in
fetchzip {
  name = "khmeros-${version}";
  url = "mirror://debian/pool/main/f/fonts-khmeros/fonts-khmeros_${version}.orig.tar.xz";
  sha256 = "sha256-pS+7RQbGwlBxdCfSVxHmARCAkZrZttwYNlV/CrxqI+w=";

  postFetch = ''
    unpackDir="$TMPDIR/unpack"
    mkdir "$unpackDir"
    cd "$unpackDir"
    tar xf "$downloadedFile" --strip-components=1
    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "KhmerOS Unicode fonts for the Khmer language";
    homepage = "http://www.khmeros.info/";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
