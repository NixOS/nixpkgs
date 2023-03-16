{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "replxx";
  version = "unstable-2023-01-21";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "replxx";
    rev = "eb6bcecff4ca6051120c99e9dd64c3bd20fcc42f";
    hash = "sha256-cb486FGF+4sUxgBbRfnbTTnZn2WQ3p93fSwDRCEtFJg=";
  };

  dontConfigure = true;
  # The CBQN derivation will build replxx, here we just provide the source files.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dev
    cp -r $src $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/replxx";
    description = "A replxx fork for CBQN";
    license = licenses.free;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk ];
    platforms = platforms.all;
  };
}
