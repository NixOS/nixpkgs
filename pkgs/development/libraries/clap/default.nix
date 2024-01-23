{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "clap";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap";
    rev = version;
    hash = "sha256-BNT2yWIlWk8kzhZteh7TaamliwJI+lzWVs/8XCFsuUc=";
  };

  postPatch = ''
    substituteInPlace clap.pc.in \
      --replace '$'"{prefix}/@CMAKE_INSTALL_INCLUDEDIR@" '@CMAKE_INSTALL_FULL_INCLUDEDIR@'
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Clever Audio Plugin API interface headers";
    homepage = "https://cleveraudio.org/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ris ];
  };
}
