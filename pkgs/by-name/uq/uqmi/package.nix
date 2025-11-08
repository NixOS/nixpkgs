{
  stdenv,
  lib,
  fetchgit,
  cmake,
  perl,
  libubox,
  json_c,
}:

stdenv.mkDerivation {
  pname = "uqmi";
  version = "unstable-2025-07-30";

  src = fetchgit {
    url = "https://git.openwrt.org/project/uqmi.git";
    rev = "7914da43cddaaf6cfba116260c81e6e9adffd5ab";
    hash = "sha256-Ny5Jd/6N1nTcv2GGP1YLFe+ljn15sUQJVAEVPvYtz3M=";
  };

  postPatch = ''
    substituteInPlace data/gen-header.pl --replace /usr/bin/env ""
    patchShebangs .
  '';

  nativeBuildInputs = [
    cmake
    perl
  ];
  buildInputs = [
    libubox
    json_c
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      # error: unknown warning option '-Wno-dangling-pointer' [-Werror,-Wunknown-warning-option]
      "-Wno-error=unknown-warning-option"
    ]
  );

  meta = with lib; {
    description = "Tiny QMI command line utility";
    homepage = "https://git.openwrt.org/?p=project/uqmi.git;a=summary";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [
      fpletz
      mkg20001
    ];
    mainProgram = "uqmi";
  };
}
