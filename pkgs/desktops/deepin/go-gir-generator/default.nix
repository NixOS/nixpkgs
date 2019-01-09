{ stdenv, fetchFromGitHub, pkgconfig, go, gobject-introspection,
  libgudev, deepin, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-gir-generator";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0m6g1raa2r8in4cmnw2psm0yfhnzznlwll824w0pdywx7zlwlll7";
  };

  nativeBuildInputs = [
    pkgconfig
    go
  ];

  buildInputs = [
    gobject-introspection
    libgudev
  ];

  postPatch = ''
    sed -i -e 's:/share/gocode:/share/go:' Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "GOCACHE=off"
  ];

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Generate static golang bindings for GObject";
    homepage = https://github.com/linuxdeepin/go-gir-generator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
