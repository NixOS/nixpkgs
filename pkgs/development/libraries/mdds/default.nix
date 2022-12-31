{ lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  boost,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdds";
  version = "2.0.3";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = "mdds";
    rev = finalAttrs.version;
    hash = "sha256-Y9uBJKM34UTEj/3c1w69QHhvwFcMNlAohEco0O0B+xI=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  checkInputs = [ boost ];

  postInstall = ''
    mkdir -p $out/lib/
    mv $out/share/pkgconfig $out/lib/
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/mdds/mdds";
    description = "A collection of multi-dimensional data structure and indexing algorithms";
    changelog = "https://gitlab.com/mdds/mdds/-/blob/${finalAttrs.version}/CHANGELOG";
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
})
# TODO: multi-output
