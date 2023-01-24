{ lib, fetchzip }:

fetchzip rec {
  pname = "garamond-libre";
  version = "1.4";

  url = "https://github.com/dbenjaminmiller/garamond-libre/releases/download/${version}/garamond-libre_${version}.zip";
  stripRoot = false;

  postFetch = ''
    install -Dm644 $out/*.otf -t $out/share/fonts/opentype
    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  sha256 = "6WiuUe3CHXXL/0G7wURvSIgWPQ4isl50e3OBQ+ui0U4=";

  meta = with lib; {
    homepage = "https://github.com/dbenjaminmiller/garamond-libre";
    description = "Garamond Libre font family";
    maintainers = with maintainers; [ drupol ];
    license = licenses.x11;
    platforms = platforms.all;
  };
}
