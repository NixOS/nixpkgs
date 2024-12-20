{
  stdenv,
  fetchFromGitHub,
  perl,
  lib,
  moarvm,
}:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2024.06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "raku";
    repo = "nqp";
    rev = version;
    hash = "sha256-FqZPUtzlS+ZSlyuCFMWHofLXPuXCWAT6Oak0g3o8cgM=";
    fetchSubmodules = true;
  };

  buildInputs = [ perl ];

  configureScript = "${perl}/bin/perl ./Configure.pl";

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
    "--with-moar=${moarvm}/bin/moar"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Not Quite Perl -- a lightweight Raku-like environment for virtual machines";
    homepage = "https://github.com/Raku/nqp";
    license = licenses.artistic2;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      sgo
    ];
  };
}
