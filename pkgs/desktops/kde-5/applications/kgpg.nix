{
  kdeApp, lib,
  automoc4, cmake, makeWrapper, perl, pkgconfig,
  boost, gpgme, kdelibs, kdepimlibs, gnupg
}:

kdeApp {
  name = "kgpg";
  nativeBuildInputs = [ automoc4 cmake makeWrapper perl pkgconfig ];
  buildInputs = [ boost gpgme kdelibs kdepimlibs ];
  postInstall = ''
    wrapProgram "$out/bin/kgpg" \
        --prefix PATH : "${gnupg}/bin"
  '';
  meta = {
    license = [ lib.licenses.gpl2 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
