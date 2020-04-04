{ stdenv, fetchurl, autoPatchelfHook
, ncurses5, zlib, gmp
}:

stdenv.mkDerivation rec {
  pname = "unison-code-manager";
  milestone_id = "M1i";
  version = "1.0.${milestone_id}-alpha";

  src = if (stdenv.isDarwin) then
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-osx.tar.gz";
      sha256 = "0ky77js95v41h8f9y1dizxw5r3yh9i8ichkv0qy7dxc4vqmqll6s";
    }
  else
    fetchurl {
      url = "https://github.com/unisonweb/unison/releases/download/release/${milestone_id}/unison-linux64.tar.gz";
      sha256 = "02zd57lcvc15cvnbr06hf9fidlx9cbgm8az7555k0v26d4h5iayh";
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
