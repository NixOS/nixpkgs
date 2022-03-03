{ fetchurl
, stdenv
, lib
, libGLU
, mesa
, libX11
, mesa_drivers
, autoPatchelfHook
}:
let
  # TODO: Maybe Darwin could be supported
  tags = {
    "x86_64-linux" = {
      arch = "linux-x86_64";
      sha256 = "d422720fc53f161992b264847d6173eabbe3a3710aa0045d68738ee942f3246e";
    };
    "aarch64-linux" = {
      arch = "linux-aarch64";
      sha256 = "83949d7d159b3b958153efcd62d3c7c9b160917b37a19cacda95c2cb1f0dda19";
    };
  };

  download = tags.${stdenv.system} or (builtins.abort "${stdenv.system} is currently unsupported !");
in
stdenv.mkDerivation rec {
  pname = "mujoco";
  version = "2.1.1";

  src = fetchurl {
    inherit (download) sha256;
    url = "https://github.com/deepmind/mujoco/releases/download/${version}/mujoco-${version}-${download.arch}.tar.gz";
  };

  noBuildPhase = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  # Techincally `libOSMesa.so.6` is not satsified, but it seems to work anyway
  autoPatchelfIgnoreMissingDeps = true;

  buildInputs = [
    libGLU.dev
    mesa
    libX11
    mesa_drivers.osmesa
  ];

  meta = {
    description = "Multi-Joint dynamics with Contact. A general purpose physics simulator.";
    longDescription = ''
      MuJoCo is a physics engine that aims to facilitate research and development in robotics, biomechanics, graphics and animation, and other areas where fast and accurate simulation is needed
    '';
    homepage = "https://mujoco.org/";
    maintainers = [ lib.maintainers.mazurel ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    license = with lib.licenses; [ asl20 ];
  };
}
