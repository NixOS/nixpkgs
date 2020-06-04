{ stdenv
, fetchpatch
, fetchFromGitHub
, pkgconfig
, go
, gobject-introspection
, libgudev
, deepin
}:

stdenv.mkDerivation rec {
  pname = "go-gir-generator";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1ydzll8zlk897iqcihvv6p046p0rzr4qqz2drmz2nx95njp8n03a";
  };

  patches = [
    # Fix compatibility with glib 2.63+
    # https://github.com/linuxdeepin/go-gir-generator/pull/11
    (fetchpatch {
      url = "https://github.com/linuxdeepin/go-gir-generator/commit/7dea15a1a491f28d2ac8c411068ccefeba01aae3.patch";
      sha256 = "182d30qkj1rx9ynpj9zfxh53nykvfq9wxk4502zc42gfvadgzfgd";
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
    "PREFIX=${placeholder "out"}"
    "GOCACHE=$(TMPDIR)/go-cache"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Generate static golang bindings for GObject";
    homepage = "https://github.com/linuxdeepin/go-gir-generator";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
