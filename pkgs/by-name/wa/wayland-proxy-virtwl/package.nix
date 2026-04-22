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
  version = "0-unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "wayland-proxy-virtwl";
    rev = "60e759ca3e4e26444c4956fb85e24b7944d4d81a";
    sha256 = "sha256-cqBXINcJJ8yrNzvMHio+6+eO0PFGUWR+sZSvBDxxOvs=";
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
