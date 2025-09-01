{
  lib,
  stdenvNoCC,
  clangStdenv,
  fetchFromGitHub,
  fetchurl,
  mill,
  which,
}:

let
  # we need to lock the mill version, because an update will change the
  # fetched internal dependencies, thus breaking the deps FOD
  lockedMill = mill.overrideAttrs (oldAttrs: rec {
    # should ideally match the version listed inside the `.mill-version` file of the source
    version = "0.11.12";
    src = fetchurl {
      url = "https://github.com/com-lihaoyi/mill/releases/download/${version}/${version}-assembly";
      hash = "sha256-k4/oMHvtq5YXY8hRlX4gWN16ClfjXEAn6mRIoEBHNJo=";
    };
  });
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "vyxal";
  version = "3.4.9";

  src = fetchFromGitHub {
    owner = "Vyxal";
    repo = "Vyxal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8hA4u9zz8jm+tlSZ88z69/PUFNYk7+i3jtgUntgDgPE=";
  };

  # make sure to resolve all dependencies needed
  deps = stdenvNoCC.mkDerivation {
    name = "vyxal-${finalAttrs.version}-deps";
    inherit (finalAttrs) src;

    nativeBuildInputs = [ lockedMill ];

    buildPhase = ''
      runHook preBuild

      export JAVA_TOOL_OPTIONS="-Duser.home=$(mktemp -d)"
      export COURSIER_CACHE=$out/.coursier

      mill native.prepareOffline --all

      runHook postBuild
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-yXKzntb498b8ZLYq7w+s1Brj+pvPN9otdkdY8QGVHPs=";
  };

  nativeBuildInputs = [
    lockedMill
    which
  ];

  buildPhase = ''
    runHook preBuild

    export JAVA_TOOL_OPTIONS="-Duser.home=$(mktemp -d)"
    export COURSIER_CACHE=${finalAttrs.deps}/.coursier

    mill native.nativeLink

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 out/native/nativeLink.dest/out $out/bin/vyxal
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/Vyxal/Vyxal/releases/tag/v${finalAttrs.version}";
    description = "Code-golfing language that has aspects of traditional programming languages";
    homepage = "https://github.com/Vyxal/Vyxal";
    license = lib.licenses.mit;
    mainProgram = "vyxal";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
