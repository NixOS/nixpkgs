{ stdenv, fetchFromGitHub, deepin }:

stdenv.mkDerivation rec {
  pname = "go-dbus-factory";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "06fqyad9f50gcjsjkh7929yyaprahdjhnd0dr4gl2797a7wysl3f";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    sed -i -e 's:/share/gocode:/share/go:' Makefile
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "GoLang DBus factory for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/go-dbus-factory;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
