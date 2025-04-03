{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "unzoo";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "unzoo";
    rev = version;
    hash = "sha256-oPq1I7EsvHaJ7anHbm/KWrYrxJkM79rLhgRfSAdoLtk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  buildPhase = ''
    runHook preBuild

    ${stdenv.cc.targetPrefix}cc -o unzoo -DSYS_IS_UNIX src/unzoo.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $doc/share/doc/unzoo
    cp unzoo $out/bin
    cp README.TXT $doc/share/doc/unzoo

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/museoa/unzoo/";
    description = "Manipulate archives of files in Zoo compressed form";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
    mainProgram = "unzoo";
  };
}
