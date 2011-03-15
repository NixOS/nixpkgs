{ stdenv, fetchgit, cmake, kdelibs, automoc4 }:

stdenv.mkDerivation rec {
  name = "liblikeback-20110103";

  src = fetchgit {
    url = git://anongit.kde.org/liblikeback.git;
    rev = "eeb037ae16b6aad8d73cbd6f57198aa111a88628";
    sha256 = "1p3c8hqfcbhjfyn1kj636kq52nb3vapfakmqvp2wklpljyq38f3z";
  };

  buildInputs = [ cmake kdelibs automoc4 ];

  meta = {
    description = "Simple feedback button/dialog for KDE 4.x applications";
    homepage = https://projects.kde.org/projects/playground/libs/liblikeback;
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
