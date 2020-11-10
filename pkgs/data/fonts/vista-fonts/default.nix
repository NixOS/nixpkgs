{stdenv, fetchzip, cabextract}:

fetchzip {
  name = "vista-fonts-1";

  url = "https://web.archive.org/web/20171225132744/http://download.microsoft.com/download/E/6/7/E675FFFC-2A6D-4AB0-B3EB-27C9F8C8F696/PowerPointViewer.exe";

  postFetch = ''
    ${cabextract}/bin/cabextract --lowercase --filter ppviewer.cab $downloadedFile
    ${cabextract}/bin/cabextract --lowercase --filter '*.TTF' ppviewer.cab

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    # Set up no-op font configs to override any aliases set up by
    # other packages.
    mkdir -p $out/etc/fonts/conf.d
    for name in Calibri Cambria Candara Consolas Constantia Corbel ; do
      substitute ${./no-op.conf} $out/etc/fonts/conf.d/30-''${name,,}.conf \
        --subst-var-by fontname $name
    done
  '';

  sha256 = "1l27zg5jraa16zm11d3qz1w7m6f1ih3xy5avww454ylm50fw6z11";

  meta = {
    description = "Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)";
    homepage = "http://www.microsoft.com/typography/ClearTypeFonts.mspx";
    license = stdenv.lib.licenses.unfree; # haven't read the EULA, but we probably can't redistribute these files, so...

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
  };
}
