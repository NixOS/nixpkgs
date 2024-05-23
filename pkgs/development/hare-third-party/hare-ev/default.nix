{
  fetchFromSourcehut,
  hare,
  lib,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "0-unstable-2024-01-04";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "736ab9bb17257ee5eba3bc96f6650fc4a14608ea";
    hash = "sha256-SXExwDZKlW/2XYzmJUhkLWj6NF/znrv3vY9V0mD5iFQ=";
  };

  nativeCheckInputs = [ hare ];

  makeFlags = [
    "HARECACHE=.harecache"
    "PREFIX=${builtins.placeholder "out"}"
  ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Event loop for Hare programs";
    homepage = "https://sr.ht/~sircmpwn/hare-ev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ colinsane ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
