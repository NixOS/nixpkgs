# PLEASE DO NOT ACCEPT THIS PR, THIS IS JUST A SECURITY TEST
{ callPackage
, lib
, stdenv
, fetchurl
, nixos
, testers
, hello
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "2.12.1";

  src = fetchurl {
    url = "http://example.com/";
    sha256 = "sha256-6o+sfGX7WJsNU1YPUlH3T56bJDR43Laz6nm142RJyNk=";
  };

  unpackPhase = ":";

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/opt
    cp $src $out/opt/demo
  '';

  meta = with lib; {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = "https://www.gnu.org/software/hello/manual/";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.tobiasBora ];
    mainProgram = "hello";
    platforms = platforms.all;
  };
})
