{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "cppreference-doc";
  version = "20220730";

  src = fetchurl {
    url = "https://github.com/PeterFeicht/${pname}/releases/download/v${version}/html-book-${version}.tar.xz";
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
