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
  version = "0-unstable-2026-09-04";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "wayland-proxy-virtwl";
    rev = "aa515e518a9e0de117d3b77b7e9db91aea7dcfbc";
    sha256 = "sha256-VIm6jr9SfACtCQjrmELy64wECpuTjxQ3WlTQBL64rXI=";
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
    cmdliner_1
    logs
    ppx_cstruct
  ]);

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/talex5/wayland-virtwl-proxy";
    description = "Proxy Wayland connections across a VM boundary";
    license = lib.licenses.asl20;
    mainProgram = "wayland-proxy-virtwl";
    maintainers = [
      lib.maintainers.qyliss
      lib.maintainers.sternenseemann
    ];
    platforms = lib.platforms.linux;
  };
}
