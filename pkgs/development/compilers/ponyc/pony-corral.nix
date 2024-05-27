{ lib
, stdenv
, fetchFromGitHub
, ponyc
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corral";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "corral";
    rev = finalAttrs.version;
    hash = "sha256-+pHg5BFHlScC1suad0/3RqKAnxoEVZNUNj1EDLvbsfA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Corral is a dependency management tool for ponylang (ponyc)";
    homepage = "https://www.ponylang.io";
    changelog = "https://github.com/ponylang/corral/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ redvers ];
    inherit (ponyc.meta) platforms;
  };
})
