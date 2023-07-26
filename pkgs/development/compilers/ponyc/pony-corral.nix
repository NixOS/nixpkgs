{ lib
, stdenv
, fetchFromGitHub
, ponyc
, nix-update-script
}:

stdenv.mkDerivation ( rec {
  pname = "corral";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = "f31353a9ec9cd7eab6ee89079ae6a782192fd4b5";
    hash = "sha256-jTx/7iFvmwOdjGVf/6NUy+FTkv6Mkv8DeotJ67pvmtc=";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
