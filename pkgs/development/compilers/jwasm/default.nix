{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "jwasm";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "Baron-von-Riedesel";
    repo  = "JWasm";
    rev = "v${version}";
    hash = "sha256-BUSsF73Q2vq6tF/YHMUyAmmFE/WWVQLRFJZkOD8T7f8=";
  };

  outputs = [ "out" "doc" ];

  dontConfigure = true;

  preBuild = ''
    cp ${if stdenv.cc.isClang then "CLUnix.mak" else "GccUnix.mak"} Makefile
    substituteInPlace Makefile \
      --replace "/usr/local/bin" "${placeholder "out"}/bin"
  '';

  postInstall = ''
    install -Dpm644 $src/Html/License.html \
                    $src/Html/Manual.html \
                    $src/Html/Readme.html \
                    -t $doc/share/doc/jwasm/
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/Baron-von-Riedesel/JWasm/";
    description = "A MASM-compatible x86 assembler";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: generalize for Windows builds
