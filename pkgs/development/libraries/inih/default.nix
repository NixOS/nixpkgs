{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "56";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = pname;
    rev = "r${version}";
    sha256 = "sha256-7k3i3pElihastUDrdf9DyRZMe2UNFckfLUFGb4rbWLo=";
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
