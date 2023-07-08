{ lib
, stdenv
, backendStdenv
, fetchurl
, autoPatchelfHook
, autoAddOpenGLRunpathHook
, manifestAttribute ? null
}@inputs:

pname:
attrs:

let
  systemToManifestAttribute = {
    "x86_64-linux" = [ "linux-x86_64" ];
    "aarch64-linux" = [ "linux-aarch64" "linux-sbsa" ];
    "powerpc64le-linux" = [ "linux-ppc64le" ];
  };
  systemToManifestAttributeOrDefault = default: system:
    if builtins.hasAttr system systemToManifestAttribute && builtins.length systemToManifestAttribute.${system} > 0
    then builtins.head systemToManifestAttribute.${system}
    else default; # Avoids evaluation errors on missing attributes
  isSystemSupported = system: builtins.any (at: builtins.hasAttr at attrs) systemToManifestAttribute.${system};
  supportedPlatforms = builtins.concatMap
    (system: if isSystemSupported system then [ system ] else [ ])
    (builtins.attrNames systemToManifestAttribute);

  inherit (stdenv) system;

  manifestAttribute =
    if !inputs?manifestAttribute || inputs.manifestAttribute == null
    then systemToManifestAttributeOrDefault "linux-x86_64" system
    else inputs.manifestAttribute;

  # Generally, we avoid assertions in favour of setting the `meta.broken`
  # attribute, which can be overridden by the user. These tests are assertions
  # because if they fail, they likely fail even without any overrides, and their
  # failure signals a coding error right in this file.
  validAttributeChoice = lib.assertMsg (builtins.hasAttr manifestAttribute attrs) "Trying to evaluate ${pname} for ${system}, but the chosen attribue (${manifestAttribute}) isn't in the manifest";
in

assert validAttributeChoice;
assert builtins.all
  (system: builtins.elem system lib.platforms.all)
  (builtins.attrNames systemToManifestAttribute);

backendStdenv.mkDerivation {
  inherit pname;
  inherit (attrs) version;

  src = fetchurl {
    url = "https://developer.download.nvidia.com/compute/cuda/redist/${attrs.${manifestAttribute}.relative_path}";
    inherit (attrs.${manifestAttribute}) sha256;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    # This hook will make sure libcuda can be found
    # in typically /lib/opengl-driver by adding that
    # directory to the rpath of all ELF binaries.
    # Check e.g. with `patchelf --print-rpath path/to/my/binary
    autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    # autoPatchelfHook will search for a libstdc++ and we're giving it
    # one that is compatible with the rest of nixpkgs, even when
    # nvcc forces us to use an older gcc
    # NB: We don't actually know if this is the right thing to do
    stdenv.cc.cc.lib
  ];

  # Picked up by autoPatchelf
  # Needed e.g. for libnvrtc to locate (dlopen) libnvrtc-builtins
  appendRunpaths = [
    "$ORIGIN"
  ];

  dontBuild = true;

  # TODO: choose whether to install static/dynamic libs
  installPhase = ''
    runHook preInstall
    rm LICENSE
    mkdir -p $out
    mv * $out
    runHook postInstall
  '';

  passthru.stdenv = backendStdenv;
  passthru.manifestAttribute = manifestAttribute;

  meta = {
    description = attrs.name;
    license = lib.licenses.unfree;
    maintainers = lib.teams.cuda.members;
    platforms = supportedPlatforms;
  };
}
