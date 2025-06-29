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

  version = "0.24.2";
in
stdenv.mkDerivation {
  pname = "hare-ssh";
  inherit version;

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ssh";
    rev = version;
    hash = "sha256-koH/M3Izyjz09SO29TF3+zWIgCxwZn024FDQPSLn1FY=";
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
