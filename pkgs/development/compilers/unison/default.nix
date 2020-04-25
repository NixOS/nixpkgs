{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1j";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "1pvdjmasgl22inbr8nlizsg8s5zagn8bzwhaxqmwafkpsskz0hsg";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "1xpblx405cp3mv0vrhcqwjlxvrhgmc77mxbvcy93srxja3qai1af";
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
    homepage = "https://unisonweb.org/";
    license = with licenses; [ mit bsd3 ];
    maintainers = [ maintainers.virusdave ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };
}
