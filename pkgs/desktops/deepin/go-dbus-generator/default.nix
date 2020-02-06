{ stdenv, fetchFromGitHub, go, go-lib, deepin }:

stdenv.mkDerivation rec {
  pname = "go-dbus-generator";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "17rzicqizyyrhjjf4rild7py1cyd07b2zdcd9nabvwn4gvj6lhfb";
  };

  nativeBuildInputs = [
    go
    go-lib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "GOCACHE=$(TMPDIR)/go-cache"
  ];

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Convert dbus interfaces to go-lang or qml wrapper code";
    homepage = https://github.com/linuxdeepin/go-dbus-generator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
