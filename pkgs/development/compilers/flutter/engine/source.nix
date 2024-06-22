{
  callPackage,
  hostPlatform,
  targetPlatform,
  tools ? callPackage ./tools.nix { inherit hostPlatform; },
  curl,
  pkg-config,
  git,
  python3,
  runCommand,
  writeText,
  cacert,
  version,
  hashes,
  url,
}:
let
  constants = callPackage ./constants.nix { inherit targetPlatform; };
in
runCommand "flutter-engine-source-${version}-${targetPlatform.system}"
  {
    pname = "flutter-engine-source";
    inherit version;

    inherit (tools) depot_tools;

    nativeBuildInputs = [
      curl
      pkg-config
      git
      tools.cipd
      (python3.withPackages (
        ps: with ps; [
          httplib2
          six
        ]
      ))
    ];

    gclient = writeText "flutter-engine-${version}.gclient" ''
      solutions = [{
        "managed": False,
        "name": "src/flutter",
        "url": "${url}",
      }]
    '';

    NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    DEPOT_TOOLS_UPDATE = "0";
    DEPOT_TOOLS_COLLECT_METRICS = "0";
    PYTHONDONTWRITEBYTECODE = "1";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = hashes.${targetPlatform.system} or (throw "Hash not set for ${targetPlatform.system}");
  }
  ''
    source ${../../../../build-support/fetchgit/deterministic-git}
    export -f clean_git
    export -f make_deterministic_repo

    mkdir -p $out
    cp $gclient $out/.gclient
    cd $out

    export PATH=$PATH:$depot_tools
    python3 $depot_tools/gclient.py sync --no-history --shallow --nohooks >/dev/null
    find $out -name '.git' -exec dirname {} \; | xargs bash -c 'make_deterministic_repo $@' _
    find $out -path '*/.git/*' ! -name 'HEAD' -prune -exec rm -rf {} \;
    find $out -name '.git' -exec mkdir {}/logs \;
    find $out -name '.git' -exec cp {}/HEAD {}/logs/HEAD \;

    python3 src/build/linux/sysroot_scripts/install-sysroot.py --arch=${constants.arch} >/dev/null

    rm -rf $out/.cipd $out/.gclient $out/.gclient_entries $out/.gclient_previous_custom_vars $out/.gclient_previous_sync_commits
  ''
