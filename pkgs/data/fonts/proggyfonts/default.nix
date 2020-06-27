{ lib, mkFont, fetchurl }:

mkFont {
  pname = "proggyfonts";
  version = "0.1";

  src = fetchurl {
    url = "https://web.archive.org/web/20150801042353/http://kaictl.net/software/proggyfonts-0.1.tar.gz";
    sha256 = "1plcm1sjpa3hdqhhin48fq6zmz3ndm4md72916hd8ff0w6596q0n";
  };

  dontBuild = false;
  buildPhase = ''
    # duplicated as Speedy11.pcf
    rm Speedy.pcf
    for f in *.pcf; do
      gzip -n -9 "$f"
    done
  '';

  meta = with lib; {
    homepage = "http://upperbounds.net";
    description = "A set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.myrl ];
  };
}
