{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kotlin";
  version = "2.2.21";

  src = fetchurl {
    url = "https://github.com/JetBrains/kotlin/releases/download/v${finalAttrs.version}/kotlin-compiler-${finalAttrs.version}.zip";
    sha256 = "sha256-piOHHxzZyTiUaUi3DvkXCHnwdYBDiFu9MMMvAk5RFxQ=";
  };

  propagatedBuildInputs = [ jre ];
  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    mkdir -p $out
    rm "bin/"*.bat
    mv * $out

    for p in $(ls $out/bin/) ; do
      wrapProgram $out/bin/$p --prefix PATH ":" ${jre}/bin ;
    done

    if [ -f $out/LICENSE ]; then
      install -D $out/LICENSE $out/share/kotlin/LICENSE
      rm $out/LICENSE
    fi
  '';

  meta = {
    description = "General purpose programming language";
    longDescription = ''
      Kotlin is a statically typed language that targets the JVM and JavaScript.
      It is a general-purpose language intended for industry use.
      It is developed by a team at JetBrains although it is an OSS language
      and has external contributors.
    '';
    homepage = "https://kotlinlang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SubhrajyotiSen ];
    platforms = lib.platforms.all;
  };
})
