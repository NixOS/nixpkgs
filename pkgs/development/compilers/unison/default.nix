{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1h";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "0iivm5gmbk0fq0zr3lvck6p1c2i7i54l3rf70z677529w9irzchp";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "0fb84c1yn8pidflh7kq696j3v4blkvbk1fsqp36h30p7vv676yci";
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
    homepage = https://unisonweb.org/;
    license = with licenses; [ mit bsd3 ];
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
