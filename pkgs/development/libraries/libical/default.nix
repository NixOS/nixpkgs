{ stdenv, fetchFromGitHub, perl, cmake }:

stdenv.mkDerivation rec {
  name = "libical-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "libical";
    repo = "libical";
    rev = "v${version}";
    sha256 = "1y6rbw24m133d984pyqzx2bi7f37dsw6f33l6arwn6yd4zlqdib9";
  };

  nativeBuildInputs = [ perl cmake ];

  patches = [ ./respect-env-tzdir.patch ];

  meta = with stdenv.lib; {
    homepage = https://github.com/libical/libical;
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
