{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.3.3";
  pname = "scala-bare";

  src = fetchurl {
    url = "https://github.com/scala/scala3/releases/download/${finalAttrs.version}/scala3-${finalAttrs.version}.tar.gz";
    hash = "sha256-61lAETEvqkEqr5pbDltFkh+Qvp+EnCDilXN9X67NFNE=";
  };

  propagatedBuildInputs = [
    jre
    ncurses.dev
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';

  # Use preFixup instead of fixupPhase
  # because we want the default fixupPhase as well
  preFixup = ''
    bin_files=$(find $out/bin -type f ! -name "*common*" ! -name "scala-cli.jar")
    for f in $bin_files ; do
      wrapProgram $f --set JAVA_HOME ${jre} --prefix PATH : '${ncurses.dev}/bin'
    done
  '';

  meta = with lib; {
    description = "The Scala 3 compiler, also known as Dotty";
    homepage = "https://scala-lang.org/";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "scala";
    maintainers = with maintainers; [
      karolchmist
      virusdave
      kashw2
      natsukagami
      hamzaremmal
      dottybot
    ];
  };
})
