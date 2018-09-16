{ stdenv, fetchFromGitHub, pkgconfig, go, gobjectIntrospection, libgudev }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "go-gir-generator";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0yi3lsgkxi8ghz2c7msf2df20jxkvzj8s47slvpzz4m57i82vgzl";
  };

  nativeBuildInputs = [
    pkgconfig
    go
  ];

  buildInputs = [
    gobjectIntrospection
    libgudev
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "HOME=$(TMP)"
  ];

  meta = with stdenv.lib; {
    description = "Generate static golang bindings for GObject";
    homepage = https://github.com/linuxdeepin/go-gir-generator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
