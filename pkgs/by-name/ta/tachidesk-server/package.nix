{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jdk17_headless
, callPackage
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tachidesk-server";
  version = "0.7.0";
  revision = 1197;

  src = fetchurl {
    url = "https://github.com/Suwayomi/Tachidesk-Server/releases/download/v0.7.0/Tachidesk-Server-v${finalAttrs.version}-r${toString finalAttrs.revision}.jar";
    sha256 = "sha256-4DO1WiBCu/8ypFgJdBmEwQXQ1xaWAlbt8N5TELomVVA=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk17_headless}/bin/java $out/bin/tachidesk-server --add-flags "-jar $src"
  '';

  meta = with lib; {
    description = "A free and open source manga reader server that runs extensions built for Tachiyomi.";
    long_description = ''
      A free and open source manga reader server that runs extensions built for Tachiyomi.

      Tachidesk is an independent Tachiyomi compatible software and is not a Fork of Tachiyomi.

      Tachidesk-Server is as multi-platform as you can get. Any platform that runs java and/or has a modern browser can run it. This includes Windows, Linux, macOS, chrome OS, etc.
    '';
    homepage = "https://github.com/Suwayomi/Tachidesk-Server";
    license = licenses.mpl20;
    platforms = jdk17_headless.meta.platforms;
    maintainers = with maintainers; [ ratcornu ];
  };
})
