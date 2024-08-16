{
  fetchFromSourcehut,
  hareHook,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "0-unstable-2024-07-11";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "ed023beb4b4db88e22f608aa001682ac18cad230";
    hash = "sha256-bZWVrxk3CMAHRnizRAqgT5wmRQaQ/Ua3AIAR5HZxMbE=";
  };

  nativeCheckInputs = [ hareHook ];

  makeFlags = [ "PREFIX=${builtins.placeholder "out"}" ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Event loop for Hare programs";
    homepage = "https://sr.ht/~sircmpwn/hare-ev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ colinsane ];
    inherit (hareHook.meta) platforms badPlatforms;
  };
}
