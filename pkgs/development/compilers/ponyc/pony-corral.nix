{ lib, stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation ( rec {
  pname = "corral";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = version;
    sha256 = "sha256-Rv1K6kFRylWodm1uACBs8KqqEqQZh86NqAG50heNteE=";
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
