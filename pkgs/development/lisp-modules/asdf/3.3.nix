{ lib, stdenv, fetchurl, fetchpatch, texinfo, texLive, perl }:

stdenv.mkDerivation rec {
  pname = "asdf";
  version = "3.3.6";

  src = fetchurl {
    url = "http://common-lisp.net/project/asdf/archives/asdf-${version}.tar.gz";
    sha256 = "sha256-NkjvNlLqJnBAfOxC9ECTtmuS5K+0v5ZXOw2xt8l7vgk=";
  };

  patches = [
    # Clasp bytecode support
    (fetchpatch {
      url = "https://github.com/clasp-developers/asdf/compare/fe6e3ab741c71ecebc8503e20637d4c940326421..615771b3d0ee6ebb158134769e88ba421c2ea7d1.diff";
      hash = "sha256-jrv/vH4uxLVvaCK4UicNzIePQ12lscA0auwgTMb4QwI=";
    })
  ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
}
