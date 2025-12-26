{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "xmlformat";
  version = "1.9-unstable-2021-09-15";

  src = fetchFromGitHub {
    owner = "someth2say";
    repo = "xmlformat";
    rev = "15a22213b341ab2800806f052a32d29898fecaad";
    hash = "sha256-XCjvGeMerSqyMaVEu6EvLuwgsOxZ/v6ahgFCbzRqC7w=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/xmlformat.pl $out/bin/xmlformat
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Configurable formatter (or 'pretty-printer') for XML documents";
    homepage = "https://github.com/someth2say/xmlformat";
    license = lib.licenses.gpl3Only;
    mainProgram = "xmlformat";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.all;
  };
}
