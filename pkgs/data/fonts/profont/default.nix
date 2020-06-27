{ lib, mkFont, fetchurl, unzip }:

mkFont {
  pname = "profont";
  version = "2019-11";

  srcs = [
    (fetchurl {
      name = "profont-x11.zip";
      url = "https://tobiasjung.name/downloadfile.php?file=profont-x11.zip";
      sha256 = "19ww5iayxzxxgixa9hgb842xd970mwghxfz2vsicp8wfwjh6pawr";
    })

    (fetchurl {
      name = "profont-otb.zip";
      url = "https://tobiasjung.name/downloadfile.php?file=profont-otb.zip";
      sha256 = "07lh237w68s5fmv466jpahn8vlnkr82sjw9vr91w36k8nfsiyx24";
    })
  ];

  nativeBuildInputs = [ unzip ];

  dontBuild = false;
  sourceRoot = ".";
  buildPhase = ''
    cd profont-x11
    for f in *.pcf; do
      gzip -n -9 "$f"
    done
    cd ..
  '';

  meta = with lib; {
    homepage = "https://tobiasjung.name/profont/";
    description = "A monospaced font created to be a most readable font for programming";
    maintainers = with maintainers; [ myrl ];
    license = licenses.mit;
    platforms = platforms.all;
  };

}
