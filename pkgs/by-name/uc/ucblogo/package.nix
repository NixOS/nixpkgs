{ lib
, stdenv
, fetchFromGitHub
, wxGTK32
, texinfo
, tetex
, wrapGAppsHook3
, autoconf-archive
, autoreconfHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ucblogo-code";
  version = "6.2.4";

  src = fetchFromGitHub {
    owner = "jrincayc";
    repo = "ucblogo-code";
    rev = "ca23b30a62eaaf03ea203ae71d00dc45a046514e";
    hash = "sha256-BVNKkT0YUqI/z5W6Y/u3WbrHmaw7Z165vFt/mlzjd+8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    texinfo
    tetex
    wrapGAppsHook3
  ];

  buildInputs = [
    wxGTK32
  ];

  meta = with lib; {
    description = "Berkeley Logo interpreter";
    homepage = "https://github.com/jrincayc/ucblogo-code";
    changelog = "https://github.com/jrincayc/ucblogo-code/blob/${finalAttrs.src.rev}/changes.txt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ matthewcroughan ];
    mainProgram = "ucblogo-code";
    platforms = platforms.all;
  };
})
