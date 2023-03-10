{ lib, stdenv, fetchurl, ocaml, gd, freetype, findlib, zlib, libpng, libjpeg }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-gd4o";
  version = "1.0a5";

  src = fetchurl {
    url = "mirror://sourceforge/gd4o/gd4o/1.0%20Alpha%205/gd4o-1.0a5.tar.gz";
    sha256 = "1vbyakz7byvxmqf3hj68rw15b4kb94ppcnhvmjv38rsyg05bc47s";
  };

  buildInputs = [ ocaml findlib libjpeg libpng ];
  propagatedBuildInputs = [ gd zlib freetype ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR/stublibs
  '';

  buildFlags = [ "all" "opt" ];

  checkPhase = ''
    runHook preCheck
    make test.opt
    runHook postCheck
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/gd4o/";
    description = "OCaml wrapper for the GD graphics library";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
