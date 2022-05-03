{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "53";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = pname;
    rev = "r${version}";
    sha256 = "0dqf5j2sw4hq68rqvxbrsf44ygfzx9ypiyzipk4cvp9aimbvsbc6";
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
