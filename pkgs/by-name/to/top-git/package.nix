{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "topgit";
  version = "0.19.13";

  src = fetchFromGitHub {
    owner = "mackyle";
    repo = "topgit";
    rev = "${pname}-${version}";
    sha256 = "sha256-K0X1DGc1LQsoteUhoHLxVJRrZaaPLKSSF61OKyGB5Qg=";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  nativeBuildInputs = [
    perl
    git
  ];

  postInstall = ''
    install -Dm644 README -t "$out/share/doc/${pname}-${version}/"
    install -Dm755 contrib/tg-completion.bash -t "$out/share/bash-completion/completions/"
  '';

  meta = {
    description = "TopGit manages large amount of interdependent topic branches";
    mainProgram = "tg";
    homepage = "https://github.com/mackyle/topgit";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ marcweber ];
  };
}
