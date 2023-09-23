{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "singeli";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "Singeli";
    rev = "49a6a90d83992171a2db749e9f7fd400ec65ef2c";
    hash = "sha256-9Dc6yrrXV6P9s1uwGlXB+ZBquOLejWe41k0TSpJGDgE=";
  };

  dontConfigure = true;
  # The CBQN derivation will build Singeli, here we just provide the source files.
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dev
    cp -r $src $out/dev

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/mlochbaum/Singeli";
    description = "A metaprogramming DSL for SIMD";
    license = licenses.isc;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk detegr ];
    platforms = platforms.all;
  };
}
