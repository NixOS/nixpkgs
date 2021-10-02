{ lib
, stdenv
, fetchFromGitHub
, bqn-path ? null
}:

let
  mlochbaum-bqn = fetchFromGitHub {
    owner = "mlochbaum";
    repo = "BQN";
    rev = "97cbdc67fe6a9652c42daefadd658cc41c1e5ae3";
    hash = "sha256-F2Bv3n3C7zAhqKCMB6hT2iIWTjEqFdLBMyX6/w7V1SY=";
  };

  cbqn-bytecode = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "fdf0b93409d68d5ffd86c5670db27c240e6039e0";
    hash = "sha256-A0zvpg+G37WNgyfrJuc5rH6L7Wntdbrz8pYEPreqgKE=";
  };
in

stdenv.mkDerivation {
  pname = "cbqn";
  version = "0.0.0+unstable=2021-09-29";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "1c83483d5395e097f60de299274ebe0df590217e";
    hash = "sha256-C34DpXab08mBm2oCQuaeq4fJPtQ5rVa/HlpL/nB9XjQ=";
  };

  dontConfigure = true;

  patches = [
    # self-explaining
    ./001-remove-vendoring.diff
  ];

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
  '';

  preBuild =
    if bqn-path == null
    then ''
      cp ${cbqn-bytecode}/src/gen/{compiler,formatter,runtime0,runtime1,src} src/gen/
    ''
    else ''
      ${bqn-path} genRuntime ${mlochbaum-bqn}
    '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "single-o3"
  ];

  installPhase = ''
     runHook preInstall

     mkdir -p $out/bin/
     cp BQN -t $out/bin/
     ln -s $out/bin/BQN $out/bin/bqn
     ln -s $out/bin/BQN $out/bin/cbqn

     runHook postInstall
  '';

  doInstallCheck = with stdenv; hostPlatform.isCompatible buildPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/bqn" "${mlochbaum-bqn}/test/this.bqn" | grep "All passed"
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
# TODO: factor BQN
