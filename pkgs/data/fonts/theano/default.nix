{ lib, fetchzip }:

let
  version = "2.0";
in fetchzip rec {
  name = "theano-${version}";

  url = "https://github.com/akryukov/theano/releases/download/v${version}/theano-${version}.otf.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/doc/${name}
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "1my1symb7k80ys33iphsxvmf6432wx6vjdnxhzhkgrang1rhx1h8";

  meta = with lib; {
    homepage = https://github.com/akryukov/theano;
    description = "An old-style font designed from historic samples";
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
