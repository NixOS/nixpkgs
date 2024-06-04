{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "58";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-b2f6hQvkmWgni/zdfv3I1b9ypd7zSyEBv/JVBA6K7/w=";
  };

  nativeBuildInputs = [ meson ninja ];

  meta = with lib; {
    description = "Simple .INI file parser in C, good for embedded systems";
    homepage = "https://github.com/benhoyt/inih";
    changelog = "https://github.com/benhoyt/inih/releases/tag/r${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ TredwellGit ];
    platforms = platforms.all;
  };
}
