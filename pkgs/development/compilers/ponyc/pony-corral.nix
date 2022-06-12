{ lib, stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation ( rec {
  pname = "corral";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "sha256-OLA09C/6s2PyzreBvqFfzsoRDXiRMbdf3Jgnmawr7k4=";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
