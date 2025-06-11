{
  coreutils,
  fetchurl,
  gnugrep,
  lib,
  makeWrapper,
  moreutils,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zstxtns-utils";
  version = "0.0.3";

  src = fetchurl {
    url = "https://ytrizja.de/distfiles/zstxtns-utils-${version}.tar.gz";
    sha256 = "I/Gm7vHUr29NClYWQ1kwu8HrNZpdLXfE/nutTNoqcdU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin zstxtns-merge zstxtns-unmerge
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/zstxtns-merge --set PATH "${
      lib.makeBinPath [
        coreutils
        gnugrep
        moreutils
      ]
    }"
    wrapProgram $out/bin/zstxtns-unmerge --set PATH "${
      lib.makeBinPath [
        coreutils
        gnugrep
      ]
    }"
  '';

  meta = with lib; {
    description = "utilities to deal with text based name service databases";
    homepage = "https://ytrizja.de/";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
