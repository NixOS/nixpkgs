{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lm_sensors,
  yaml-cpp,
  pkg-config,
  procps,
  coreutils,
  smartSupport ? false,
  libatasmart,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "thinkfan";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "vmatare";
    repo = "thinkfan";
    tag = finalAttrs.version;
    hash = "sha256-QqDWPOXy8E+TY5t0fFRAS8BGA7ZH90xecv5UsFfDssk=";
  };

  postPatch = # fix hardcoded install path
  ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc" "$out/etc"
  ''
  # fix command paths in unit files
  + ''
    substituteInPlace rcscripts/systemd/thinkfan-sleep.service \
      --replace-fail "/usr/bin/pkill" "${lib.getExe' procps "pkill"}"
    substituteInPlace rcscripts/systemd/thinkfan-sleep.service \
      --replace-fail "ExecStart=sleep " "ExecStart=${lib.getExe' coreutils "sleep"} "
    substituteInPlace rcscripts/systemd/thinkfan-wakeup.service \
      --replace-fail "/usr/bin/pkill" "${lib.getExe' procps "pkill"}"
    substituteInPlace rcscripts/systemd/thinkfan.service.cmake \
      --replace-fail "/bin/kill" "${lib.getExe' procps "kill"}"
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_DOCDIR=share/doc/thinkfan"
    "-DUSE_NVML=OFF"
    # force install unit files
    "-DSYSTEMD_FOUND=ON"
  ]
  ++ lib.optional smartSupport "-DUSE_ATASMART=ON";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    lm_sensors
    yaml-cpp
  ]
  ++ lib.optional smartSupport libatasmart;

  meta = {
    description = "Simple, lightweight fan control program";
    longDescription = ''
      Thinkfan is a minimalist fan control program. Originally designed
      specifically for IBM/Lenovo Thinkpads, it now supports any kind of
      system via the sysfs hwmon interface (/sys/class/hwmon).
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/vmatare/thinkfan";
    maintainers = with lib.maintainers; [
      rnhmjoj
    ];
    platforms = lib.platforms.linux;
    mainProgram = "thinkfan";
  };
})
