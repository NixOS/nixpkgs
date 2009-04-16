{ cabal, libedit } :

cabal.mkDerivation (self : {
  pname = "editline";
  version = "0.2";
  sha256 = "6ee0b553cc8d7542c096730ceebabdcb9b2951d7b00a5a0ddbf47b5436a77ce4";
  propagatedBuildInputs = [ libedit ];
  patchLibFiles = [ "editline.buildinfo.in" ];
  preConfigure = ''
    sed -i -e '/el_get/d' include/HsEditline.h
  '';
  # I don't quite understand why ncurses as an extra-library is harmful, but
  # it works only if we remove it ...
  postConfigure = ''
    sed -i -e 's/ncurses//' editline.buildinfo
  '';
  meta = {
    description = "Binding to the BSD editline library";
  };
})  

