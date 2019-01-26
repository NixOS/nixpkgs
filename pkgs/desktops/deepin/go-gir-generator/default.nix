{ stdenv, fetchFromGitHub, pkgconfig, go, gobject-introspection,
  libgudev, deepin, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-gir-generator";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0grp4ffy3vmlknzmymnxq1spwshff2ylqsw82pj4y2v2fcvnqfvb";
  };

  patches = [
    # fix: dde-api build error with gobject-introspection 1.58+
    (fetchurl {
      url = https://github.com/linuxdeepin/go-gir-generator/commit/a7ab229201e28d1be727f5021b3588fa4a1acf5f.patch;
      sha256 = "13ywalwkjg8wwvd0pvmc2rv1h38airyvimdn9jfb5wis9xm48401";
    })
  ];

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
