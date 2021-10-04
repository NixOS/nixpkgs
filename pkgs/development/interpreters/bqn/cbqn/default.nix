{ lib
, stdenv
, fetchFromGitHub
, genBytecode ? false
, bqn-path ? null
, mbqn-source ? null
}:

let
  cbqn-bytecode-files = fetchFromGitHub {
    name = "cbqn-bytecode-files";
    owner = "dzaima";
    repo = "CBQN";
    rev = "94bb312d20919f942eabed3dca33c514de3c3227";
    hash = "sha256-aFw5/F7/sYkYmxAnGeK8EwkoVrbEcjuJAD9YT+iW9Rw=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));
stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.0.0+unstable=2021-10-01";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "3725bd58c758a749653080319766a33169551536";
    hash = "sha256-xWp64inFZRqGGTrH6Hqbj7aA0vYPyd+FdetowTMTjPs=";
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
    if genBytecode
    then ''
      ${bqn-path} genRuntime ${mbqn-source}
    ''
    else ''
      cp ${cbqn-bytecode-files}/src/gen/{compiler,formatter,runtime0,runtime1,src} src/gen/
    '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
     runHook preInstall

     mkdir -p $out/bin/
     cp BQN -t $out/bin/
     ln -s $out/bin/BQN $out/bin/bqn
     ln -s $out/bin/BQN $out/bin/cbqn

     runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/dzaima/CBQN/";
    description = "BQN implementation in C";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres sternenseemann synthetica ];
    platforms = platforms.all;
    priority = if genBytecode then 0 else 10;
  };
}
# TODO: factor and version cbqn-bytecode-files
# TODO: test suite
