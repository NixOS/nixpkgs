{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "terminus-font-ttf";
  version = "4.47.0";

  src = fetchzip {
    url = "http://files.ax86.net/terminus-ttf/files/${version}/terminus-ttf-${version}.zip";
    sha256 = "13kalpyn75hrxhggs9yijrcrb00qdphlvbg69cvn6xryfnrrfan6";
  };

  meta = with lib; {
    description = "A clean fixed width TTF font";
    longDescription = ''
      Monospaced bitmap font designed for long work with computers
      (TTF version, mainly for Java applications)
    '';
    homepage = "http://files.ax86.net/terminus-ttf";
    license = licenses.ofl;
    maintainers = with maintainers; [ okasu ];
  };
}
