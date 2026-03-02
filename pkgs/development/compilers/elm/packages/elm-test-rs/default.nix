{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchzip,
  openssl,
  stdenv,
  nodejs,
  elmPackages,
  writableTmpDirAsHomeHook,
  runCommand,
}:
let
  # provide an elm dependencies cache and registry for all the test case projects
  # see update.sh for how it is created
  elmDeps = builtins.fromJSON (builtins.readFile ./elm-srcs.json);

  setupDepsCache = lib.concatMapStrings (
    dep:
    let
      dep_src = fetchzip {
        pname = "${dep.author}_${dep.package}";
        inherit (dep) sha256 version;
        url = "https://github.com/${dep.author}/${dep.package}/archive/${dep.version}.tar.gz";
      };
    in
    ''
      dep_dir=$pkgs_dir/${dep.author}/${dep.package}/${dep.version}
      mkdir -p $dep_dir
      cp -r ${dep_src}/. $dep_dir
    ''
  ) elmDeps;

  elm-deps =
    runCommand "elm-deps"
      {
        buildInputs = [ ];
      }
      ''
        pkgs_dir=$out/${elmPackages.elm.version}/packages

        mkdir -p $pkgs_dir
        cp ${./registry.dat} $pkgs_dir/registry.dat

        ${setupDepsCache}
      '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "elm-test-rs";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "mpizenberg";
    repo = "elm-test-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NGonWCOLxON1lxsgRlWgY67TtIJYsLPXi96NcxF4Tso=";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  cargoHash = "sha256-qs6ujXl4j9gCEDQV5i47oa0eaqWZf4NqsVbNDsao5fI=";

  nativeCheckInputs = [
    nodejs
    elmPackages.elm
    writableTmpDirAsHomeHook
  ];

  # use the default ELM_HOME location to avoid more troubles
  preCheck = ''
    mkdir -p $HOME/.elm
    cp -r --no-preserve=mode ${finalAttrs.passthru.elm-deps}/. $HOME/.elm
  '';

  passthru.elm-deps = elm-deps;
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Fast and portable executable to run your Elm tests";
    mainProgram = "elm-test-rs";
    homepage = "https://github.com/mpizenberg/elm-test-rs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      jpagex
      zupo
    ];
  };
})
