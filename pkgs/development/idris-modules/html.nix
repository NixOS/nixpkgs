{
  build-idris-package,
  fetchFromGitHub,
  idrisscript,
  hrtime,
  webgl,
  lib,
}:
build-idris-package {
  pname = "html";
  version = "2017-04-23";

  idrisDeps = [
    idrisscript
    hrtime
    webgl
  ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-html";
    rev = "f59ecc560d7008ba26dda83f11319bb24ed6c508";
    hash = "sha256-EUAreSB2tQgvTH0N3fiMzVp8iD7LzapNHn406uemTGQ=";
  };

  postUnpack = ''
    sed -i "s/hrTime/hrtime/g" source/html.ipkg
  '';

  meta = {
    description = "Idris library to interact with HTML";
    homepage = "https://github.com/pierrebeaucamp/idris-html";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
