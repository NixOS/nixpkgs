{ stdenv
, lib
, fetchFromSourcehut
, hare
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "hare-ev";
  version = "unstable-2023-12-04";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-ev";
    rev = "e3c3f7613c602672ac41a3e47c106a5bd27a2378";
    hash = "sha256-TQsR2lXJfkPu53WpJy/K+Jruyfw8mCkEIE9DbFQoS+s=";
  };

  nativeCheckInputs = [
    hare
  ];

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
