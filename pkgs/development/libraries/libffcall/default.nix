{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libffcall";
  version = "2.2";

  src = fetchurl {
    url = "mirror://gnu/libffcall/libffcall-${version}.tar.gz";
    sha256 = "sha256-6/o3+XtslPrCTs8xk/n8gpUXz4Gu6awtGRr5k9c8t0c=";
  };

  enableParallelBuilding = false;

  outputs = [ "dev" "out" "doc" "man" ];

  postInstall = ''
    mkdir -p $doc/share/doc/libffcall
    mv $out/share/html $doc/share/doc/libffcall
    rm -rf $out/share
  '';

  meta = with lib; {
    description = "Foreign function call library";
    homepage = "https://www.gnu.org/software/libffcall/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
