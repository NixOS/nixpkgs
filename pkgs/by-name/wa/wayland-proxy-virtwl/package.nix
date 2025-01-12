{
  lib,
  fetchFromGitHub,
  ocamlPackages,
  pkg-config,
  libdrm,
  unstableGitUpdater,
}:

ocamlPackages.buildDunePackage rec {
  pname = "wayland-proxy-virtwl";
  version = "0-unstable-2025-01-07";

  src = fetchFromGitHub {
    owner = "talex5";
    repo = pname;
    rev = "a49bb541a7b008e13be226b3aaf0c4bda795af26";
    sha256 = "sha256-lX/ccHV1E7iAuGqTig+fvcY22qyk4ZJui17nLotaWjw=";
  };

  minimalOCamlVersion = "5.0";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [ libdrm ]
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
