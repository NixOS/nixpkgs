{ pkgs, fetchurl, lib, stdenv, unzip }:
stdenv.mkDerivation {
  pname = "inchi";
  version = "1.05";
  src = fetchurl {
    url = "http://www.inchi-trust.org/download/105/INCHI-1-SRC.zip";
    sha1 = "e3872a46d58cb321a98f4fd4b93a989fb6920b9c";
  };

  nativeBuildInputs = [ pkgs.unzip ];
  outputs = [ "out" "doc" ];

  enableParallelBuilding = true;

  preBuild = ''
    cd ./INCHI_API/libinchi/gcc
  '';
  installPhase = ''
    cd ../../..
    mkdir -p $out/lib
    mkdir -p $out/include/inchi
    mkdir -p $doc/share/

    install -m 755 INCHI_API/bin/Linux/libinchi.so.1.05.00 $out/lib
    ln -s $out/lib/libinchi.so.1.05.00 $out/lib/libinchi.so.1
    ln -s $out/lib/libinchi.so.1.05.00 $out/lib/libinchi.so
    install -m 644 INCHI_BASE/src/*.h $out/include/inchi

    runHook postInstall
  '';

  postInstall =
    let
      src-doc = fetchurl {
        url = "http://www.inchi-trust.org/download/105/INCHI-1-DOC.zip";
        sha1 = "2f54y0san34v01c215kk0cigzsn76js5";
      };
    in
    ''
      unzip '${src-doc}'
      install -m 644 INCHI-1-DOC/*.pdf $doc/share
    '';

  meta = with lib; {
    homepage = "https://www.inchi-trust.org/";
    description = "IUPAC International Chemical Identifier library";
    license = licenses.lgpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
