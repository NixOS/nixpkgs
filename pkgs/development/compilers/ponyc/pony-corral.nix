{ lib
, stdenv
, fetchFromGitHub
, ponyc
<<<<<<< HEAD
, nix-update-script
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation ( rec {
  pname = "corral";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "unstable-2023-02-11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = pname;
    rev = "f31353a9ec9cd7eab6ee89079ae6a782192fd4b5";
    hash = "sha256-jTx/7iFvmwOdjGVf/6NUy+FTkv6Mkv8DeotJ67pvmtc=";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
})
