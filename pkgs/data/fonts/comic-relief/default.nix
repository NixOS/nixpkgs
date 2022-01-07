{ lib, fetchzip }:

let
  version = "1.1";
in fetchzip rec {
  name = "comic-relief-${version}";

  url = "https://fontlibrary.org/assets/downloads/comic-relief/45c456b6db2aaf2f7f69ac66b5ac7239/comic-relief.zip";

  postFetch = ''
    mkdir -p $out/etc/fonts/conf.d
    mkdir -p $out/share/doc/${name}
    mkdir -p $out/share/fonts/truetype
    cp -v ${./comic-sans-ms-alias.conf}     $out/etc/fonts/conf.d/30-comic-sans-ms.conf
    unzip -j $downloadedFile \*.ttf      -d $out/share/fonts/truetype
    unzip -j $downloadedFile FONTLOG.txt -d $out/share/doc/${name}
  '';

  sha256 = "0dz0y7w6mq4hcmmxv6fn4mp6jkln9mzr4s96vsg68wrl5b7k9yff";

  meta = with lib; {
    homepage = "https://fontlibrary.org/en/font/comic-relief";
    description = "A font metric-compatible with Microsoft Comic Sans";
    longDescription = ''
      Comic Relief is a typeface designed to be metrically equivalent
      to the popular Comic Sans MS. Comic Relief can be used in place
      of Comic Sans MS without having to move, resize, or reset any
      part of the copy. It contains all glyphs and characters
      available in Comic Sans MS.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [maintainers.rycee];

    # Reduce the priority of this package. The intent is that if you
    # also install the `corefonts` package, then you probably will not
    # want to install the font alias of this package.
    priority = 10;
  };
}
