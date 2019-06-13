{ stdenv
, autoconf
, automake
, libtool
, intltool
, fetchFromGitHub
}:

stdenv.mkDerivation {
  name = "ddccontrol-db-20180908";
  src = fetchFromGitHub {
    owner = "ddccontrol";
    repo = "ddccontrol-db";
    rev = "5f211be363f77dc43e39f911b30f4fb19a2d7a84";
    sha256 = "0vi3bzxpjdkn791vri68k7dah4v2liscniz7hxrarhl4fxlicc0w";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  buildInputs =
    [
      autoconf
      automake
      libtool
      intltool
    ];

  meta = with stdenv.lib; {
    description = "Monitor database for DDCcontrol";
    homepage = https://github.com/ddccontrol/ddccontrol-db;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pakhfn ];
  };
}
