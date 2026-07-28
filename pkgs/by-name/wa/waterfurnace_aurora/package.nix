{
  lib,
  fetchpatch2,
  bundlerApp,
  bundlerUpdateScript,
  defaultGemConfig,
}:

bundlerApp {
  pname = "waterfurnace_aurora";

  gemdir = ./.;
  exes = [
    "aurora_fetch"
    "aurora_mock"
    "aurora_monitor"
    "aurora_mqtt_bridge"
    "web_aid_tool"
  ];

  gemConfig = defaultGemConfig // {
    ccutrer-serialport = attrs: {
      dontBuild = false;
      patches = [
        (fetchpatch2 {
          name = "use-numeric-baud-rates.patch";
          url = "https://github.com/ccutrer/ccutrer-serialport/commit/52f5c1cba94fe9453444baa79dd7c08b2efab8bf.patch?full_index=1";
          hash = "sha256-KKH/RXhql/3jl3/xheZmQ16Rv1w0/AWV7WfCZQb1Xlk=";
        })
      ];
    };
  };

  passthru.updateScript = bundlerUpdateScript "waterfurnace_aurora";

  meta = {
    description = "Tools for communication with WaterFurnace Aurora control systems";
    homepage = "https://github.com/ccutrer/waterfurnace_aurora";
    license = lib.licenses.mit;
    mainProgram = "aurora_mqtt_bridge";
    maintainers = with lib.maintainers; [ majiir ];
  };
}
