{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "singeli";
  version = "unstable-2023-04-27";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "Singeli";
    rev = "853ab1a06ae8d8603f228d8e784fa319cc401459";
    hash = "sha256-X/NnufvakihJAE9H7geuuDS7Tv9l7tgLKdRgXC4ZX4A=";
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
