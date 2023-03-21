{ lib, stdenvNoCC, fetchurl }:

let
  pname = "cppreference-doc";
  version = "2022.07.30";
  ver = builtins.replaceStrings ["."] [""] version;
in
stdenvNoCC.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/PeterFeicht/${pname}/releases/download/v${ver}/html-book-${ver}.tar.xz";
    hash = "sha256-cfFQA8FouNxaAMuvGbZICps+h6t+Riqjnttj11EcAos=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cppreference/doc
    mv reference $out/share/cppreference/doc/html

    runHook postInstall
  '';

  passthru = { inherit pname version; };

  meta = with lib; {
    description = "C++ standard library reference";
    homepage = "https://en.cppreference.com";
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ panicgh ];
    platforms = platforms.all;
  };
}
