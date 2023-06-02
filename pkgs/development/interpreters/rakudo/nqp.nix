{ stdenv, fetchFromGitHub, perl, lib, moarvm }:

stdenv.mkDerivation rec {
  pname = "nqp";
  version = "2023.05";

  src = fetchFromGitHub {
    owner = "raku";
    repo = "nqp";
    rev = version;
    hash = "sha256-34fPD/6gokOmcwNyUAh6B5BcRt/PWBc3pIvMP8lq6NE=";
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
    maintainers = with maintainers; [ thoughtpolice vrthra sgo ];
  };
}
