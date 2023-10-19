{ lib, stdenv, dockapps-sources
, libX11
, libXpm
, libXext
, libdockapp }:

stdenv.mkDerivation rec {
  pname = "wmsm.app";
  version = "0.2.1";

  src = dockapps-sources;

  buildInputs = [ libX11 libXpm libXext libdockapp ];

  setSourceRoot = ''
    export sourceRoot=$(echo */${pname}/wmsm)
  '';

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace Makefile \
      --replace "PREFIX	= /usr/X11R6/bin" "" \
      --replace "/usr/bin/install" "install"
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install -d ${placeholder "out"}/bin
    runHook postInstall
  '';

  installFlags = [ "PREFIX=${placeholder "out"}/bin" ];

  meta = with lib; {
    description = "System monitor for Windowmaker";
    homepage = "https://www.dockapps.net/wmsmapp";
    license = licenses.gpl2;
    maintainers = [ maintainers.bstrik ];
  };
}
