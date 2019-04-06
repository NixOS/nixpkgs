{ stdenv, fetchFromGitHub, pkgconfig, go, gobject-introspection,
  libgudev, deepin, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-gir-generator";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0d93qzp3dlia5d1yxw0rwca76qk3jyamj9xzmk13vzig8zw0jx16";
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
    "PREFIX=${placeholder ''out''}"
    "GOCACHE=$(TMPDIR)/go-cache"
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
