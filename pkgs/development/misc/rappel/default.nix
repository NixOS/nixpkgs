{ fetchFromGitHub
, libedit
, makeWrapper
, nasm
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "rappel";
  version = "unstable-2019-09-09";

  src = fetchFromGitHub {
    owner = "yrp604";
    repo = "rappel";
    rev = "31a06762d34880ff2ed7176ca71bd8a6b91b10d5";
    sha256 = "0wj3hypqfrjra8mwmn32hs5qs6ic81cq3gn1v0b2fba6vkqcsqfy";
  };

  buildInputs = [ libedit ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin bin/rappel
    wrapProgram $out/bin/rappel --prefix PATH : "${nasm}/bin"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/yrp604/rappel";
    description = "A pretty janky assembly REPL";
    mainProgram = "rappel";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.pamplemousse ];
    platforms = platforms.linux;
  };
}
