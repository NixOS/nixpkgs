{ stdenv, fetchFromGitHub, pkgconfig, go, deepin-gettext-tools, dbus-factory
, go-gir-generator, go-lib, go-dbus-factory, go-x11-client

}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-api";
  version = "3.1.30";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0piw6ka2xcbd5vi7m33d1afdjbb7nycxvmai530ka6r2xjabrkir";
  };

  netSrc = fetchFromGitHub {
    owner = "golang";
    repo = "net";
    rev = "161cd47e91fd58ac17490ef4d742dc98bb4cf60e";
    sha256 = "0254ld010iijygbzykib2vags1dc0wlmcmhgh4jl8iny159lhbcv";
    };

  nativeBuildInputs = [
    pkgconfig
    go
    go-lib
    go-gir-generator
    go-dbus-factory
    go-x11-client
  ];

  buildInputs = [
  ];

  makeFlags = [
    #"PREFIX=$(out)"
    #"GOPATH=$(GOPATH):${go-lib}/share/gocode:${go-gir-generator}/share/gocode:${go-dbus-factory}/share/gocode:${go-x11-client}/share/gocode"
    #"HOME=$(TMP)"
  ];

  preBuild = ''
    echo ${netSrc}
    #false
    export GOPATH=$GOPATH:${go-lib}/share/gocode:${go-gir-generator}/share/gocode:${go-dbus-factory}/share/gocode:${go-x11-client}/share/gocode
  '';

  meta = with stdenv.lib; {
    description = "Go-lang bindings for dde-daemon";
    homepage = https://github.com/linuxdeepin/dde-api;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
