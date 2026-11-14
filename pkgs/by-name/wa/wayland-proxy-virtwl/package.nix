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
  version = "0-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = "wayland-proxy-virtwl";
    rev = "4123710fdbae57f8d5bc0d0ecce836680e8ead53";
    sha256 = "sha256-3a8DG2GmXXifvngg37UrpQxkUWE0aJucItWwJu+evsQ=";
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
