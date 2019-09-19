{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cascadia-code";
  version = "1909.16";

  src = fetchurl {
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/Cascadia.ttf";
    sha256 = "14qxvjhg1sswf3zssc4bkmjg5qy9k2md0zkhdq3zjh5w7wqmsj60";
  };

  dontUnpack = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/Cascadia.ttf

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/microsoft/cascadia-code;
    description = "A fun, new monospaced font that includes programming ligatures by Microsoft.";
    license = licenses.ofl;
    maintainers = with maintainers; [ eadwu ];
    platforms = platforms.all;
  };
}
