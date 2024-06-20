{
  lib,
  stdenv,

  cacert,
  git,
  zig,
  zigmod,
}:

{
  pname,
  version,
  src,
  lockFile,
  manifestFile,
  depsOutputHash,
  buildFlags ? "",
  meta ? { },
  nativeBuildInputs ? [ ],
  postUnpack ? "",
  preBuild ? "",
  ...
}@attrs:
let
  depsDir = ".zigmod";

  deps = stdenv.mkDerivation {
    name = "${pname}-deps.tar.gz";

    inherit pname version;

    srcs = [
      lockFile
      manifestFile
    ];

    sourceRoot = ".";

    unpackPhase = ''
      cp ${lockFile} $sourceRoot/zigmod.lock
      cp ${manifestFile} $sourceRoot/zigmod.yml
      chmod -R u+w $sourceRoot
    '';

    nativeBuildInputs = [
      cacert
      git
      zigmod
    ];

    buildPhase = ''
      zigmod fetch
    '';

    installPhase = ''
      find ${depsDir} -name .git -type d -prune -exec rm -rf {} \;;
      # Build a reproducible tar, per instructions at https://reproducible-builds.org/docs/archives/
      tar --owner=0 --group=0 --numeric-owner --format=gnu \
          --sort=name --mtime="@$SOURCE_DATE_EPOCH" \
          -czf $out -C ${depsDir} .
    '';

    outputHash = depsOutputHash;
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (
  attrs
  // {
    inherit pname version src;

    nativeBuildInputs = [
      zig
      zigmod
    ] ++ nativeBuildInputs;

    postUnpack =
      ''
        mkdir -p $sourceRoot/${depsDir}
        tar -xf ${deps} -C $sourceRoot/${depsDir}
      ''
      + postUnpack;

    buildPhase =
      attrs.buildPhase or ''
        runHook preBuild

        zigmod fetch
        zig build -Doptimize=ReleaseSafe -Dcpu=baseline ${buildFlags} --prefix $out

        runHook postBuild
      '';

    preBuild =
      ''
        export XDG_CACHE_HOME="$(mktemp -d)"
      ''
      + preBuild;

    meta = {
      inherit (zig.meta) platforms;
    } // meta;
  }
)
