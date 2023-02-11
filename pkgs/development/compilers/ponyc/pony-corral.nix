{ lib
, stdenv
, fetchFromGitHub
, ponyc
}:

stdenv.mkDerivation ( rec {
  pname = "corral";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Rv1K6kFRylWodm1uACBs8KqqEqQZh86NqAG50heNteE=";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
