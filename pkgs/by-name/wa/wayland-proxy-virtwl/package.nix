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
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "wayland-proxy-virtwl";
    rev = "34d499a119b9a903730144ba5836e70a73f812ac";
    sha256 = "sha256-eU0HU0808Tp4Mw+RY2CZVikFIL1lk6rJg6lNVWj35jg=";
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
