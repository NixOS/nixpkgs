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
    sha256 = "1il6pxbllf4rs0wf2s6q6h72m3p1d6ymgsllpkmadnw1agif0fri";
  };
in
assert genBytecode -> ((bqn-path != null) && (mbqn-source != null));
stdenv.mkDerivation rec {
  pname = "cbqn" + lib.optionalString (!genBytecode) "-standalone";
  version = "0.0.0+unstable=2021-10-05";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "CBQN";
    rev = "e23dab20daff9c0dacc2561c616174af72029a3e";
    sha256 = "17h8fb9a0hjindbxgkljajl1hjr8rdqrb85s5lz903v17wl4lrba";
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
    priority = if genBytecode then 0 else 10;
  };
}
# TODO: factor and version cbqn-bytecode-files
# TODO: test suite
