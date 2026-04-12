{
  dart,
  dart-bin,
  fetchFromGitHub,
  fetchgit,
  lib,
  newScope,
  stdenv,
  engineRuntimeModes ? [
    "release"
    "debug"
    "profile"
  ],
  supportedTargetFlutterPlatforms ? [
    "universal"
    "web"
  ]
  ++ (lib.optionals (stdenv.hostPlatform.isLinux) [ "linux" ])
  ++ (lib.optionals (stdenv.hostPlatform.isx86_64) [ "android" ])
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    "macos"
    "ios"
  ]),
}:

versionData:
lib.makeScope newScope (
  self:
  versionData
  // {
    inherit supportedTargetFlutterPlatforms;

    constants = self.callPackage ./constants.nix { };

    depot_tools = fetchgit {
      url = "https://chromium.googlesource.com/chromium/tools/depot_tools.git";
      rev = "a0e694f18f15b364d2f9c23c4dde396bfc973fd1";
      postFetch = ''
        substituteInPlace $out/gerrit_util.py \
          --replace-fail "import httplib2.socks" "httplib2.socks = None"
        substituteInPlace $out/gerrit_util.py \
          --replace-fail "httplib2.socks.socksocket._socksocket__rewriteproxy = __fixed_rewrite_proxy" "pass"
        substituteInPlace $out/gerrit_util.py \
          --replace-fail "httplib2.socks.PROXY_TYPE_HTTP_NO_TUNNEL" "3"
      '';
      hash = "sha256-N9xBfLS8DnBjOD149EOu5pr8ffBOb39vebhFUwPBllc=";
    };

    flutterSource = fetchFromGitHub {
      owner = "flutter";
      repo = "flutter";
      tag = self.version;
      hash = self.flutterHash;
    };

    dart =
      let
        hash =
          self.dartHash.${
            if (stdenv.hostPlatform.isLinux && (lib.versionAtLeast self.version "3.41")) then
              "linux"
            else
              stdenv.hostPlatform.system
          } or (throw "No dart hash for ${stdenv.hostPlatform.system}");
      in
      (if (lib.versionAtLeast self.version "3.41") then dart else dart-bin).overrideAttrs (oldAttrs: {
        version = self.dartVersion;
        src = oldAttrs.src.overrideAttrs (_: {
          version = self.dartVersion;
          outputHash = hash;
        });
      });

    cipd = self.callPackage ./cipd.nix { };

    engine = self.callPackage ./engine/default.nix { };

    engines =
      let
        enginePackages = map (
          runtimeMode: self.callPackage ./engine/default.nix { runtimeMode = runtimeMode; }
        ) engineRuntimeModes;
        outputs = lib.unique (builtins.concatMap (e: e.outputs) enginePackages);
        mergedOutputs = lib.genAttrs outputs (
          outputName:
          let
            found = lib.findFirst (e: e ? ${outputName}) null enginePackages;
          in
          found.${outputName}
        );
      in
      mergedOutputs
      // {
        inherit outputs;
      };

    host-artifacts = self.callPackage ./host-artifacts.nix { };

    all-artifacts = self.callPackage ./all-artifacts.nix { };

    flutter-tools = self.callPackage ./flutter-tools.nix { };

    flutter = self.callPackage ./flutter.nix { scope = self; };
  }
)
