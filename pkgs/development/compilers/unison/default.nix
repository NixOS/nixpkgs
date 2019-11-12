{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1d";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "0cgkqwniw2fclsxgx6b1kgjmylqnn67kjs61iygzbpip8nvcm7pv";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "0rpz40d23daad16r2s4appiay3brbk0awp38yamavlr6dh23c9ws";
    };

  # The tarball is just the prebuilt binary, in the archive root.
  sourceRoot = ".";
  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = stdenv.lib.optional (!stdenv.isDarwin) autoPatchelfHook;
  buildInputs = stdenv.lib.optionals (!stdenv.isDarwin) [ ncurses5 zlib gmp ];

  installPhase = ''
    mkdir -p $out/bin
    mv ucm $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Modern, statically-typed purely functional language";
    homepage = http://unisonweb.org/posts/;
    license = licenses.free;
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
