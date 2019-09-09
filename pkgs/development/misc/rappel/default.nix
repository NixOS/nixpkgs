{ fetchFromGitHub
, libedit
, makeWrapper
, nasm
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "rappel";
  version = "unstable-2019-07-08";

  src = fetchFromGitHub {
    owner = "yrp604";
    repo = "rappel";
    rev = "95a776f850cf6a7c21923a2100b605408ef038de";
    sha256 = "0fmd15xa6hswh3x48av4g1sf6rncbiinbj7gbw1ffvqsbcfnsgcr";
  };

  buildInputs = [ libedit ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/rappel
    wrapProgram $out/bin/rappel --prefix PATH : "${nasm}/bin"

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/yrp604/rappel";
    description = "A pretty janky assembly REPL";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.pamplemousse ];
    platforms = platforms.linux;
  };
}
