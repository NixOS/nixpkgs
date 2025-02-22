{
  fetchFromSourcehut,
  hareHook,
  lib,
  nix-update-script,
  stdenv,
}:

let
  inherit (lib) licenses;
  inherit (lib.maintainers) patwid;

  version = "0.24.0";
in
stdenv.mkDerivation {
  pname = "hare-ssh";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ssh";
    rev = version;
    hash = "sha256-I43TLPoImBsvkgV3hDy9dw0pXVt4ezINnxFtEV9P2/M=";
  };

  nativeBuildInputs = [ hareHook ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://git.sr.ht/~sircmpwn/hare-ssh/";
    description = "SSH client & server protocol implementation for Hare";
    license = licenses.mpl20;
    maintainers = [ patwid ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
}
