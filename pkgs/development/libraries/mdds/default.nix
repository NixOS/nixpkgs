{ lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  boost,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdds";
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "mdds";
    repo = "mdds";
    rev = finalAttrs.version;
    hash = "sha256-RZ2wGwle4raWlogc5X+VEeriPGS0Nqs7CWGENFEotvs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  nativeCheckInputs = [ boost ];

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
