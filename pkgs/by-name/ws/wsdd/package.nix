{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  nixosTests,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "wsdd";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "christgau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T8/XlQpx4CtNy8LuLwOQBG9muFe9pp5583tDaCT4ReI=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [ python3 ];

  installPhase = ''
    install -Dm0555 src/wsdd.py $out/bin/wsdd
    installManPage man/wsdd.8
    wrapProgram $out/bin/wsdd --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    tests.samba-wsdd = nixosTests.samba-wsdd;
  };

  meta = with lib; {
    homepage = "https://github.com/christgau/wsdd";
    description = "Web Service Discovery (WSD) host daemon for SMB/Samba";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "wsdd";
  };
}
