{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnum4,
  pkg-config,
  python3,
  intel-gpu-tools,
  libdrm,
  libva,
  enableHybridCodec ? false,
  vaapi-intel-hybrid,
  enableGui ? true,
  libX11,
  libGL,
  wayland,
  libXext,
}:

stdenv.mkDerivation rec {
  pname = "intel-vaapi-driver";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-vaapi-driver";
    rev = version;
    sha256 = "1cidki3av9wnkgwi7fklxbg3bh6kysf8w3fk2qadjr05a92mx3zp";
  };

  # Set the correct install path:
  LIBVA_DRIVERS_PATH = "${placeholder "out"}/lib/dri";

  postInstall = lib.optionalString enableHybridCodec ''
    ln -s ${vaapi-intel-hybrid}/lib/dri/* $out/lib/dri/
  '';

  configureFlags = [
    (lib.enableFeature enableGui "x11")
    (lib.enableFeature enableGui "wayland")
  ] ++ lib.optional enableHybridCodec "--enable-hybrid-codec";

  nativeBuildInputs = [
    autoreconfHook
    gnum4
    pkg-config
    python3
  ];

  buildInputs =
    [
      intel-gpu-tools
      libdrm
      libva
    ]
    ++ lib.optionals enableGui [
      libX11
      libXext
      libGL
      wayland
    ]
    ++ lib.optional enableHybridCodec vaapi-intel-hybrid;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://01.org/linuxmedia";
    license = licenses.mit;
    description = "VA-API user mode driver for Intel GEN Graphics family";
    longDescription = ''
      This VA-API video driver backend provides a bridge to the GEN GPUs through
      the packaging of buffers and commands to be sent to the i915 driver for
      exercising both hardware and shader functionality for video decode,
      encode, and processing.
      VA-API is an open-source library and API specification, which provides
      access to graphics hardware acceleration capabilities for video
      processing. It consists of a main library and driver-specific acceleration
      backends for each supported hardware vendor.
    '';
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
