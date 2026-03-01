{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

let
  compileFlags = lib.concatStringsSep " " (
    [
      "-O3"
      "-DNDEBUG"
    ]
    ++ lib.optional (stdenv.hostPlatform.isUnix) "-Dunix -pthread"
    ++ lib.optional (!stdenv.hostPlatform.isx86) "-DNOJIT"
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zpaqd";
  version = "715";

  src = fetchurl {
    url = "http://mattmahoney.net/dc/zpaqd${finalAttrs.version}.zip";
    sha256 = "sha256-Mx87Zt0AASk0ZZCjyTzYbhlYJAXBlb59OpUWsqynyCA=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    $CXX ${compileFlags} -fPIC --shared libzpaq.cpp -o libzpaq.so
    $CXX ${compileFlags} -L. -L"$out/lib" -lzpaq zpaqd.cpp -o zpaqd
  '';

  installPhase = ''
    mkdir -p "$out"/{bin,include,lib,share/doc/zpaq}
    cp libzpaq.so "$out/lib"
    cp zpaqd "$out/bin"
    cp libzpaq.h "$out/include"
    cp readme_zpaqd.txt "$out/share/doc/zpaq"
  '';

  meta = {
    description = "ZPAQ archive (de)compressor and algorithm development tool";
    mainProgram = "zpaqd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.linux;
  };
})
