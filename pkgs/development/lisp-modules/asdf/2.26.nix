{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  texLive,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "asdf";
  version = "2.26";

  src = fetchurl {
    url = "http://common-lisp.net/project/asdf/archives/asdf-${version}.tar.gz";
    sha256 = "sha256-tuUuIlZcS+a0izXeJl3Ckp+/PYAWkZ0+Cw7blwkh9+M=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    texinfo
    texLive
    perl
  ];

  buildPhase = ''
    make asdf.lisp
    mkdir build
    ln -s ../asdf.lisp build
  '';
  installPhase = ''
    mkdir -p "$out"/lib/common-lisp/asdf/
    mkdir -p "$out"/share/doc/asdf/
    cp -r ./* "$out"/lib/common-lisp/asdf/
    cp -r doc/* "$out"/share/doc/asdf/
  '';

  meta = with lib; {
    description = "Standard software-system definition library for Common Lisp";
    homepage = "https://asdf.common-lisp.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
