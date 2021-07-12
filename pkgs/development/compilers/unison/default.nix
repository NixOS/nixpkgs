{ lib, stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
, makeWrapper
, less
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M2g";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/ucm-macos.tar.gz";
      sha256 = "1ib9pdzrfpzbi35fpwm9ym621nlydplvzgbhnyd86dbwbv3i9sga";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/ucm-linux.tar.gz";
      sha256 = "004jx7q657mkcrvilk4lfkp8xcpl2bjflpn9m2p7jzlrlk97v9nj";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ] ++ (lib.optional (!stdenv.isDarwin) autoPatchelfHook);
  buildInputs = lib.optionals (!stdenv.isDarwin) [ ncurses5 zlib gmp ];

  installPhase = ''
    mkdir -p $out/bin
    mv ucm $out/bin
    wrapProgram $out/bin/ucm --prefix PATH ":" "${lib.makeBinPath [ less ]}";
  '';

  meta = with lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = with licenses; [ mit bsd3 ];
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
