{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  z3,
}:

let
  z3_4_14_0 = z3.overrideAttrs rec {
    version = "4.14.0";
    src = fetchFromGitHub {
      owner = "Z3Prover";
      repo = "z3";
      rev = "z3-${version}";
      hash = "sha256-Bv7+0J7ilJNFM5feYJqDpYsOjj7h7t1Bx/4OIar43EI=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vampire";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "vprover";
    repo = "vampire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jRzVh1KirWi9GpOkzSGoIBUExDN1rV0b3AGwa6gWb3I=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    z3_4_14_0
  ];

  cmakeFlags = [ (lib.cmakeFeature "Z3_DIR" "${z3_4_14_0.dev}/lib/cmake") ];

  enableParallelBuilding = true;

  prePatch = ''
    rm -rf z3
  '';

  installPhase = ''
    runHook preInstall

    # some versions place the binary at ./ while others at bin/
    if test -n "$(find . -maxdepth 1 -name 'vampire*' -print -quit)"
    then
      install -m0755 -D vampire* $out/bin/vampire
    else
      install -m0755 -D bin/vampire* $out/bin/vampire
    fi

    runHook postInstall
  '';

  meta = {
    homepage = "https://vprover.github.io/";
    description = "Vampire Theorem Prover";
    mainProgram = "vampire";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sempiternal-aurora ];
  };
})
