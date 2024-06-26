{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation rec {
  pname = "fasmg";
  version = "j27m";

  src = fetchzip {
    url = "https://flatassembler.net/fasmg.${version}.zip";
    sha256 = "0qmklb24n3r0my2risid8r61pi88gqrvm1c0xvyd0bp1ans6d7zd";
    stripRoot = false;
  };

  buildPhase =
    let
      inherit (stdenv.hostPlatform) system;

      path =
        {
          x86_64-linux = {
            bin = "fasmg.x64";
            asm = "source/linux/x64/fasmg.asm";
          };
          x86_64-darwin = {
            bin = "source/macos/x64/fasmg";
            asm = "source/macos/x64/fasmg.asm";
          };
          x86-linux = {
            bin = "fasmg";
            asm = "source/linux/fasmg.asm";
          };
          x86-darwin = {
            bin = "source/macos/fasmg";
            asm = "source/macos/fasmg.asm";
          };
        }
        .${system} or (throw "Unsupported system: ${system}");

    in
    ''
      chmod +x ${path.bin}
      ./${path.bin} ${path.asm} fasmg
    '';

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    install -Dm755 fasmg $out/bin/fasmg

    mkdir -p $doc/share/doc/fasmg
    cp docs/*.txt $doc/share/doc/fasmg
  '';

  meta = with lib; {
    description = "x86(-64) macro assembler to binary, MZ, PE, COFF, and ELF";
    mainProgram = "fasmg";
    homepage = "https://flatassembler.net";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      orivej
      luc65r
    ];
    platforms = with platforms; intersectLists (linux ++ darwin) x86;
  };
}
