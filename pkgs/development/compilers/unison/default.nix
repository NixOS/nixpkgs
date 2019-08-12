{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1c";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "03q02r7qc7ybqz16kmpk2d8l9vx28kaj9x59mlxzi8a4mr0j3vzb";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "1iwynqnp1i39pyq9wc01x7y22y1qa0rrjlx40jjdgnj23y1r6jk4";
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
