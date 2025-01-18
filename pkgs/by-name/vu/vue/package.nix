{
  lib,
  stdenv,
  fetchurl,
  jre,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "vue";
  version = "3.3.0";
  src = fetchurl {
    url = "http://releases.atech.tufts.edu/jenkins/job/VUE/116/deployedArtifacts/download/artifact.1";
    sha256 = "0yfzr80pw632lkayg4qfmwzrqk02y30yz8br7isyhmgkswyp5rnx";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out"/{share/vue,bin}
    cp ${src} "$out/share/vue/vue.jar"
    echo '#!${runtimeShell}' >> "$out/bin/vue"
    echo '${jre}/bin/java -jar "'"$out/share/vue/vue.jar"'" "$@"' >> "$out/bin/vue"
    chmod a+x "$out/bin/vue"
  '';

  meta = with lib; {
    description = "Visual Understanding Environment - mind mapping software";
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.ecl20;
    mainProgram = "vue";
  };
}
