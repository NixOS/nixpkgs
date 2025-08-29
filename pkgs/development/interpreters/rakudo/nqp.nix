{
  stdenv,
  fetchFromGitHub,
  perl,
  lib,
  moarvm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nqp";
  version = "2025.06.1";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "Raku";
    repo = "nqp";
    tag = finalAttrs.version;
    hash = "sha256-zM3JilRBbx2r8s+dj9Yn8m2SQfQFnn1bxOUiz3Q7FT8=";
    fetchSubmodules = true;
  };

  configureScript = "${lib.getExe perl} ./Configure.pl";

  # Fix for issue where nqp expects to find files from moarvm in the same output:
  # https://github.com/Raku/nqp/commit/e6e069507de135cc71f77524455fc6b03b765b2f
  #
  preBuild = ''
    share_dir="share/nqp/lib/MAST"
    mkdir -p $out/$share_dir
    ln -fs ${moarvm}/$share_dir/{Nodes,Ops}.nqp $out/$share_dir
  '';

  configureFlags = [
    "--backends=moar"
    "--with-moar=${lib.getExe moarvm}"
  ];

  doCheck = true;
  nativeCheckInputs = [ perl ];

  meta = {
    description = "Lightweight Raku-like environment for virtual machines";
    homepage = "https://github.com/Raku/nqp";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      sgo
      prince213
    ];
    mainProgram = "nqp";
  };
})
