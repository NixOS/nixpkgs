{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  pkg-config,
  libdrm,
  unstableGitUpdater,
}:

ocamlPackages.buildDunePackage {
  pname = "wayland-proxy-virtwl";
  version = "0-unstable-2025-06-22";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "wayland-proxy-virtwl";
    rev = "513f8d791f405154bb4053fe29861c03dc1302f7";
    sha256 = "sha256-OBeq1p5vIoVvGPyOB03qtNo4GstYwr4MkvlFcpvI4ZI=";
  };

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libdrm
  ]
  ++ (with ocamlPackages; [
    dune-configurator
    eio_main
    ppx_cstruct
    wayland
    cmdliner
    logs
    ppx_cstruct
  ]);

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = licenses.asl20;
    mainProgram = "wayland-proxy-virtwl";
    maintainers = [
      maintainers.qyliss
      maintainers.sternenseemann
    ];
    platforms = platforms.linux;
  };
}
