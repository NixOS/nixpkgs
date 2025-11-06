{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
}:

stdenv.mkDerivation {
  pname = "triehash";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "julian-klode";
    repo = "triehash";
    rev = "debian/0.3-3";
    hash = "sha256-LxVcYj2WKHbhNu5x/DFkxQPOYrVkNvwiE/qcODq52Lc=";
  };

  nativeBuildInputs = [
    perlPackages.perl
  ];

  postPatch = ''
    patchShebangs triehash.pl
  '';

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/doc/triehash/ $out/share/triehash/
    install triehash.pl $out/bin/triehash
    install README.md $out/share/doc/triehash/
    cp -r tests/ $out/share/triehash/tests/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/julian-klode/triehash";
    description = "Order-preserving minimal perfect hash function generator";
    license = with licenses; mit;
    maintainers = [ ];
    platforms = perlPackages.perl.meta.platforms;
    mainProgram = "triehash";
  };
}
