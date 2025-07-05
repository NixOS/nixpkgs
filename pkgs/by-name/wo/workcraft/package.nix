{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "workcraft";
  version = "3.5.2";

  src = fetchurl {
    url = "https://github.com/workcraft/workcraft/releases/download/v${version}/workcraft-v${version}-linux.tar.gz";
    sha256 = "sha256-/Qax8cSO9j77OXNTYoZoAk5H5teWuNuR+9ubQuFq6qc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share
    cp -r * $out/share
    mkdir $out/bin
    makeWrapper $out/share/workcraft $out/bin/workcraft \
      --set JAVA_HOME "${jre}" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=gasp';
  '';

  meta = {
    homepage = "https://workcraft.org/";
    description = "Framework for interpreted graph modeling, verification and synthesis";
    mainProgram = "workcraft";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timor ];
  };
}
