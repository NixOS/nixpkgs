{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
, makeWrapper
, less
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1m";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "06pxvp753j8pr0pn02l7cswmmas5pk1vlkw83yd04h3f2rx1s61v";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "1qspvfq805d34kz031pf9sqw8kzz7h637kc8lnbjlgvwixxkxc7c";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ] ++ (stdenv.lib.optional (!stdenv.isDarwin) autoPatchelfHook);
  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [ ncurses5 zlib gmp ];

  installPhase = ''
    mkdir -p $out/bin
    mv ucm $out/bin
    wrapProgram $out/bin/ucm --prefix PATH ":" "${stdenv.lib.makeBinPath [ less ]}";
  '';

  meta = with stdenv.lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = "https://unisonweb.org/";
    license = with licenses; [ mit bsd3 ];
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
