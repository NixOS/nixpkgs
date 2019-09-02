{stdenv, fetchzip, cabextract}:

fetchzip {
  name = "vista-fonts-1";

  url = http://download.microsoft.com/download/f/5/a/f5a3df76-d856-4a61-a6bd-722f52a5be26/PowerPointViewer.exe;

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

  sha256 = "1q2d24c203vkl6pwk86frmaj6jra49hr9mydq7cnlx4hilqslw3g";

  meta = {
    description = "Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)";
    homepage = http://www.microsoft.com/typography/ClearTypeFonts.mspx;
    license = stdenv.lib.licenses.unfree; # haven't read the EULA, but we probably can't redistribute these files, so...

    # Set a non-zero priority to allow easy overriding of the
    # fontconfig configuration files.
    priority = 5;
    broken = true; # source url is 404
  };
}
