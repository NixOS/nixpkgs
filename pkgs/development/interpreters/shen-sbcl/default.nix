{ lib
, stdenv
, fetchurl
, shen-sources
, sbcl
}:

stdenv.mkDerivation rec {
  pname = "shen-sbcl";
  version = "3.0.3";

  src = fetchurl {
    url = "https://github.com/Shen-Language/shen-cl/releases/download/v${version}/shen-cl-v${version}-sources.tar.gz";
    sha256 = "0mc10jlrxqi337m6ngwbr547zi4qgk69g1flz5dsddjy5x41j0yz";
  };

  nativeBuildInputs = [ sbcl ];

  preBuild = ''
    ln -s ${shen-sources} kernel
  '';

  buildFlags = [ "build-sbcl" ];

  checkTarget = "test-sbcl";

  doCheck = true;

  installPhase = ''
    install -m755 -D bin/sbcl/shen $out/bin/shen-sbcl
  '';

  meta = with lib; {
    homepage = "https://shenlanguage.org";
    description = "Port of Shen running on Steel Bank Common Lisp";
    changelog = "https://github.com/Shen-Language/shen-cl/raw/v${version}/CHANGELOG.md";
    platforms = sbcl.meta.platforms;
    maintainers = with maintainers; [ bsima ];
    broken = true;
    license = licenses.bsd3;
  };
}
