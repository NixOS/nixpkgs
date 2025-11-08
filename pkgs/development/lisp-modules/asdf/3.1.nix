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
  version = "3.1.7";

  src = fetchurl {
    url = "http://common-lisp.net/project/asdf/archives/asdf-${version}.tar.gz";
    sha256 = "sha256-+P+FLM1mr2KRdj7bfhWq4ync86bJS/uE0Jm/E/e4HL0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    texinfo
    texLive
    perl
  ];

  buildPhase = ''
    make build/asdf.lisp
    make -C doc asdf.info asdf.html
  '';
  installPhase = ''
    mkdir -p "$out"/lib/common-lisp/asdf/
    mkdir -p "$out"/share/doc/asdf/
    cp -r ./* "$out"/lib/common-lisp/asdf/
    cp -r doc/* "$out"/share/doc/asdf/
    ln -s  "$out"/lib/common-lisp/{asdf/uiop,uiop}
  '';

  meta = with lib; {
    description = "Standard software-system definition library for Common Lisp";
    homepage = "https://asdf.common-lisp.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
