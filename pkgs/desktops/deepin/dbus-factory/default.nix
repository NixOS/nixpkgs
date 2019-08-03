{ stdenv, fetchFromGitHub, jq, libxml2, go-dbus-generator, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dbus-factory";
  version = "3.1.17";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1llq8wzgikgpzj7z36fyzk8kjych2h9nzi3x6zv53z0xc1xn4256";
  };

  nativeBuildInputs = [
    jq
    libxml2
    go-dbus-generator
  ];

  makeFlags = [ "GOPATH=${placeholder ''out''}/share/go" ];

  postPatch = ''
    sed -i -e 's:/share/gocode:/share/go:' Makefile
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Generates static DBus bindings for Golang and QML at build-time";
    homepage = https://github.com/linuxdeepin/dbus-factory;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
