{
  lib,
  stdenv,
  tcl,
  fetchFromGitHub,
  autoreconfHook,
  tk,
  libGL,
}:

tcl.mkTclDerivation {
  pname = "tkgl";
  version = "1.2.1-unstable-2026-01-07";

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "TkGL";
    rev = "e47636bc56f02ddca503f98abc65e31a0f0f0a7c";
    hash = "sha256-Y5NIKWUjbtVn9qiVzc8TsKCm4M3KbNPiBjVTBWf7ALA=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure.ac \
      --replace-fail "-arch x86_64 -arch arm64" ""
  '';

  configureFlags = [
    "--with-tk=${lib.getLib tk}/lib"
    "--with-tkinclude=${lib.getDev tk}/include"
  ];

  installTargets = [
    "install-lib-binaries"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    tk
    libGL
  ];

  meta = {
    description = "OpenGL drawing surface for Tk 8 and 9";
    homepage = "https://github.com/3-manifolds/TkGL";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [
      noiioiu
      alejo7797
    ];
  };
}
