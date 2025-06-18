{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "ticpp";
  version = "unstable-2019-01-09";

  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "ticpp";
    rev = "eb79120ea16b847ce9f483a298a394050f463d6b";
    sha256 = "0xk4cy0xbkr6326cqd1vd6b2x0rfsx4iz2sq8f5jz3yl3slxgjm2";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DBUILD_TICPP_DLL=1" ];

  installPhase = ''
    cd ..
    mkdir -p $out/lib
    install build/*.{a,so} $out/lib
    mkdir -p $out/include
    install *.h $out/include
  '';

  meta = {
    description = "Interface to TinyXML";
    license = lib.licenses.mit;
    homepage = "https://github.com/wxFormBuilder/ticpp";
  };

}
