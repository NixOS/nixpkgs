{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, go-lib,
go-gir-generator, go-dbus-factory, deepin-gettext-tools

}:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "dde-api";
  version = "3.1.30";

  goPackagePath = "pkg.deepin.io/dde/api";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0piw6ka2xcbd5vi7m33d1afdjbb7nycxvmai530ka6r2xjabrkir";
  };

  goDeps = ./deps.nix;

  buildInputs = [
    go-lib
    go-gir-generator
    go-dbus-factory
    deepin-gettext-tools
  ];

  preBuild = ''
    GOPATH=$GOPATH:${go-lib}/share/gocode
    GOPATH=$GOPATH:${go-gir-generator}/share/gocode
    GOPATH=$GOPATH:${go-dbus-factory}/share/gocode
    GOPATH=$GOPATH:${deepin-gettext-tools}/share/gocode
  '';

  meta = with stdenv.lib; {
    description = "Go-lang bindings for dde-daemon";
    homepage = https://github.com/linuxdeepin/dde-api;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
