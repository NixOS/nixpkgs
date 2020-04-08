{ stdenv, fetchFromGitHub
, cmake }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "jwasm";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "JWasm";
    repo  = "JWasm";
    rev = version;
    sha256 = "0m972pc8vk8s9yv1pi85fsjgm6hj24gab7nalw2q04l0359nqi7w";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -Dpm755 jwasm -t $out/bin/
    install -Dpm644 $src/History.txt  $src/Readme.txt \
                    $src/Doc/enh.txt $src/Doc/fixes.txt \
                    $src/Doc/gencode.txt $src/Doc/overview.txt \
                    -t $out/share/doc/jwasm/
  '';

  meta = {
    description = "A MASM-compatible x86 assembler";
    homepage = "http://jwasm.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
