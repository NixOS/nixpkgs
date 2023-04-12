{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "singeli";
  version = "unstable-2023-01-23";

  src = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "Singeli";
    rev = "0bc519ccbbe4051204d40bfc861a5bed7132e95f";
    hash = "sha256-zo4yr9t3hp6BOX1ac3md6R/O+hl5MphZdCmI8nNP9Yc=";
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
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica shnarazk ];
    platforms = platforms.all;
  };
}
