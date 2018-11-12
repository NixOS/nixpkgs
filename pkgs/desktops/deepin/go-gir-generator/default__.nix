{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, gobjectIntrospection, libgudev }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "go-gir-generator";
  version = "1.0.4";

  goPackagePath = "gir";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0yi3lsgkxi8ghz2c7msf2df20jxkvzj8s47slvpzz4m57i82vgzl";
  };

  #outputs = [ "bin" "out" ];

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    gobjectIntrospection
    libgudev
  ];

  #makeFlags = [
  #  "PREFIX=$(out)"
  #  "HOME=$(TMP)"
  #];

  buildPhase = ''
    pwd
    echo -------------------------------------
    make -C go/src/gir
    echo -------------------------------------
  '';

  installPhase = ''
    echo -------------------------------------
    make -C go/src/gir PREFIX=$out install
    echo -------------------------------------
    mkdir -p $bin
    mv $out/bin $bin
    echo -------------------------------------
  '';

  postFixup = ''
    echo -------------------------------------
    find $bin $out -ls
    echo -------------------------------------
  '';


  meta = with stdenv.lib; {
    description = "Generate static golang bindings for GObject";
    homepage = https://github.com/linuxdeepin/go-gir-generator;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
