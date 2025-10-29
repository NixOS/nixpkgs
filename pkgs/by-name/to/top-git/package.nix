{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "topgit";
  version = "0.19.14";

  src = fetchFromGitHub {
    owner = "mackyle";
    repo = "topgit";
    rev = "${pname}-${version}";
    sha256 = "sha256-FMrkoJwgBkFvi3tewtqu+b9sRuNPCNCG6BrcnAbx0sk=";
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

  meta = with lib; {
    description = "TopGit manages large amount of interdependent topic branches";
    mainProgram = "tg";
    homepage = "https://github.com/mackyle/topgit";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ marcweber ];
  };
}
