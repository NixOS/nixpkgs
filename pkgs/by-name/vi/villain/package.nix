{
  lib,
  fetchFromGitHub,
  python3,
  python3Packages,
  makeWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "villain";
  version = "2.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "t3l3machus";
    repo = "Villain";
    rev = "v${version}";
    hash = "sha256-7qZ91WEzQg9k9V/FlREW4YLlEnloeVkisDO8q/+bheo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dependencies = with python3Packages; [
    gnureadline
    netifaces
    pycryptodomex
    pyperclip
    requests
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/villain}
    rm README.md requirements.txt LICENSE.md
    cp -a * $out/share/villain/
    makeWrapper ${python3}/bin/python $out/bin/villain \
      --add-flags "$out/share/villain/Villain.py" \
      --prefix PYTHONPATH : ${python3Packages.makePythonPath dependencies}
    runHook postInstall
  '';

  meta = {
    description = "High level stage 0/1 C2 framework that can handle multiple TCP socket & HoaxShell-based reverse shells";
    homepage = "https://github.com/t3l3machus/Villain";
    license = lib.licenses.cc-by-nc-nd-40;
    mainProgram = "villain";
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = lib.platforms.unix;
  };
}
