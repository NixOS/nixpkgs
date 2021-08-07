{ lib, stdenv, fetchurl, unzip, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "inklecate";
  version = "1.0.0";

  src =
    if stdenv.isLinux then
      fetchurl {
        url    = "https://github.com/inkle/ink/releases/download/v${version}/inklecate_linux.zip";
        sha256 = "6e17db766222998ba0ae5a5da9857e34896e683b9ec42fad528c3f8bea7398ea";
        name   = "${pname}-${version}";
      }
    else if stdenv.isDarwin then
      fetchurl {
        url    = "https://github.com/inkle/ink/releases/download/v${version}/inklecate_mac.zip";
        sha256 = "b6f4dd1f95c180637ce193dbb5fa6d59aeafe49a2121a05b7822e6cbbaa6931f";
        name   = "${pname}-${version}";
      }
    else throw "Not supported on ${stdenv.hostPlatform.system}.";

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=$(pwd)";

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = ''
    unzip -qq -j $src -d $pname-$version

    rm $pname-$version/ink-engine-runtime.dll
    rm $pname-$version/ink_compiler.dll
  '';

  installPhase = ''
    mkdir -p $out/bin/

    cp $pname-$version/inklecate $out/bin/inklecate
  '';


  meta = with lib; {
    description     = "Compiler for ink, inkle's scripting language";
    longDescription = ''
      Inklecate is a command-line compiler for ink, inkle's open source
      scripting language for writing interactive narrative
      '';
    homepage        = "https://www.inklestudios.com/ink/";
    downloadPage    = "https://github.com/inkle/ink/releases";
    license         = licenses.mit;
    platforms       = platforms.unix;
    maintainers     = with maintainers; [ shreerammodi ];
  };
}
