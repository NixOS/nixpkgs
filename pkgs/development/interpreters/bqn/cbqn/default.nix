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
    rev = "4d23479cdbd5ac6eb512c376ade58077b814b2b7";
    hash = "sha256-MTvg4lOB26bqvJTqV71p4Y4qDjTYaOE40Jk4Sle/hsY=";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));

stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.pre+unstable=2021-10-05";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "e23dab20daff9c0dacc2561c616174af72029a3e";
    hash = "sha256-amVKKD9hD5A+LbqglXHLKEsYqFSSztdXs1FCoNJyCJ4=";
  };

  dontConfigure = true;

  postPatch = ''
    sed -i '/SHELL =.*/ d' makefile
  '';

  preBuild = ''
    # otherwise cbqn defaults to clang
    makeFlagsArray+=("CC=$CC")

    # inform make we are providing the runtime ourselves
    touch src/gen/customRuntime
  '' + (if genBytecode then ''
    ${bqn-path} genRuntime ${mbqn-source}
  '' else ''
    cp ${cbqn-bytecode-files}/src/gen/{compiler,formatter,runtime0,runtime1,src} src/gen/
  '');

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
  };
}
# TODO: version cbqn-bytecode-files
# TODO: test suite
