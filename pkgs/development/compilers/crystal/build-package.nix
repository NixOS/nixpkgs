{ stdenv, lib, crystal, shards, git, pkg-config, which, linkFarm, fetchFromGitHub, installShellFiles }:

{
  # Some projects do not include a lock file, so you can pass one
  lockFile ? null
  # Generate shards.nix with `nix-shell -p crystal2nix --run crystal2nix` in the projects root
, shardsFile ? null
  # We support different builders. To make things more straight forward, make it
  # user selectable instead of trying to autodetect
, format ? "make"
, installManPages ? true
  # Specify binaries to build in the form { foo.src = "src/foo.cr"; }
  # The default `crystal build` options can be overridden with { foo.options = [ "--optionname" ]; }
, crystalBinaries ? { }
, ...
}@args:

assert (builtins.elem format [ "make" "crystal" "shards" ]);
let
  mkDerivationArgs = builtins.removeAttrs args [
    "format"
    "installManPages"
    "lockFile"
    "shardsFile"
    "crystalBinaries"
  ];

  crystalLib = linkFarm "crystal-lib" (lib.mapAttrsToList
    (name: value: {
      inherit name;
      path = fetchFromGitHub value;
    })
    (import shardsFile));

  defaultOptions = [ "--release" "--progress" "--verbose" "--no-debug" ];

  buildDirectly = shardsFile == null || crystalBinaries != { };

in
stdenv.mkDerivation (mkDerivationArgs // {

  configurePhase = args.configurePhase or lib.concatStringsSep "\n"
    (
      [
        "runHook preConfigure"
      ]
      ++ lib.optional (lockFile != null) "cp ${lockFile} ./shard.lock"
      ++ lib.optionals (shardsFile != null) [
        "test -e lib || mkdir lib"
        "for d in ${crystalLib}/*; do ln -s $d lib/; done"
        "cp shard.lock lib/.shards.info"
      ]
      ++ [ "runHook postConfigure" ]
    );

  CRFLAGS = lib.concatStringsSep " " defaultOptions;

  PREFIX = placeholder "out";

  buildInputs = args.buildInputs or [ ] ++ [ crystal ]
    ++ lib.optional (format != "crystal") shards;

  nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [ git installShellFiles pkg-config which ];

  buildPhase = args.buildPhase or (lib.concatStringsSep "\n" ([
    "runHook preBuild"
  ] ++ lib.optional (format == "make")
    "make \${buildTargets:-build} $makeFlags"
  ++ lib.optionals (format == "crystal") (lib.mapAttrsToList
    (bin: attrs: ''
      crystal ${lib.escapeShellArgs ([
        "build"
        "-o"
        bin
        (attrs.src or (throw "No source file for crystal binary ${bin} provided"))
      ] ++ (attrs.options or defaultOptions))}
    '')
    crystalBinaries)
  ++ lib.optional (format == "shards")
    "shards build --local --production ${lib.concatStringsSep " " (args.options or defaultOptions)}"
  ++ [ "runHook postBuild" ]));

  installPhase = args.installPhase or (lib.concatStringsSep "\n" ([
    "runHook preInstall"
  ] ++ lib.optional (format == "make")
    "make \${installTargets:-install} $installFlags"
  ++ lib.optionals (format == "crystal") (map
    (bin: ''
      install -Dm555 ${lib.escapeShellArgs [ bin "${placeholder "out"}/bin/${bin}" ]}
    '')
    (lib.attrNames crystalBinaries))
  ++ lib.optional (format == "shards")
    "install -Dm555 bin/* -t $out/bin"
  ++ [
    ''
      for f in README* *.md LICENSE; do
        test -f $f && install -Dm444 $f -t $out/share/doc/${args.pname}
      done
    ''
  ] ++ (lib.optional installManPages ''
    if [ -d man ]; then
      installManPage man/*.?
    fi
  '') ++ [
    "runHook postInstall"
  ]));

  doCheck = args.doCheck or true;

  checkPhase = args.checkPhase or (lib.concatStringsSep "\n" ([
    "runHook preCheck"
  ] ++ lib.optional (format == "make")
    "make \${checkTarget:-test} $checkFlags"
  ++ lib.optional (format != "make")
    "crystal \${checkTarget:-spec} $checkFlags"
  ++ [ "runHook postCheck" ]));

  doInstallCheck = args.doInstallCheck or true;

  installCheckPhase = args.installCheckPhase or ''
    for f in $out/bin/*; do
      $f --help > /dev/null
    done
  '';

  meta = args.meta or { } // {
    platforms = args.meta.platforms or crystal.meta.platforms;
  };
})
