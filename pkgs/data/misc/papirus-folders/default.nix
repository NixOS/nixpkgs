{ lib, stdenv, fetchFromGitHub, getent }:

stdenv.mkDerivation rec {
  pname = "papirus-folders";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "PapirusDevelopmentTeam";
    repo = "papirus-folders";
    rev = "v${version}";
    sha256 = "sha256-BY1hnAGz31Deffy/EGKy/nuPKmpAA0u8FzPYgr1Plfs=";
  };

  buildInputs = [
    getent
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  patchPhase = ''
    substituteInPlace ./papirus-folders --replace "getent" "${getent}/bin/getent"
  '';

  meta = with lib; {
    description = "Tool to change papirus icon theme color";
    mainProgram = "papirus-folders";
    longDescription = ''
      papirus-folders is a bash script that allows changing the color of
      folders in Papirus icon theme and its forks (which based on version 20171007 and newer).
    '';
    homepage = "https://github.com/PapirusDevelopmentTeam/papirus-folders";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.aacebedo ];
  };
}
