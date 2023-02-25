{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, autoAddOpenGLRunpathHook
}:

pname:
attrs:

let
  arch = "linux-x86_64";
in
stdenv.mkDerivation {
  inherit pname;
  inherit (attrs) version;

  src = assert (lib.hasAttr arch attrs); fetchurl {
    url = "https://developer.download.nvidia.com/compute/cuda/redist/${attrs.${arch}.relative_path}";
    inherit (attrs.${arch}) sha256;
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
    # autoPatchelfHook will search for a libstdc++ and we're giving it a
    # "compatible" libstdc++ from the same toolchain that NVCC uses.
    #
    # E.g. it might happen that stdenv=gcc12Stdenv, but we build against cuda11
    # that only "supports" gcc11. Linking against gcc12's libraries we might
    # sometimes actually sometimes encounter dynamic linkage errors at runtime
    # NB: We don't actually know if this is the right thing to do
    cudatoolkit.cc.cc.lib
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

  passthru.stdenv = stdenv;

  meta = {
    description = attrs.name;
    license = lib.licenses.unfree;
    platforms = lib.optionals (lib.hasAttr arch attrs) [ "x86_64-linux" ];
  };
}
