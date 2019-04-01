{ stdenv, fetchFromGitHub, go, go-lib, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-dbus-generator";
  version = "0.6.6";

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
    "PREFIX=${placeholder ''out''}"
    "GOCACHE=$(TMPDIR)/go-cache"
  ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Convert dbus interfaces to go-lang or qml wrapper code";
    homepage = https://github.com/linuxdeepin/go-dbus-generator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
