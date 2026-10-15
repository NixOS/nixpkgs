{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  yosys,
  readline,
  zlib,
  bluespec,
}:

stdenv.mkDerivation {
  pname = "yosys-bluespec";
  version = "2021.09.08";
  plugin = "bluespec";

  src = fetchFromGitHub {
    owner = "thoughtpolice";
    repo = "yosys-bluespec";
    rev = "f6f4127a4e96e18080fd5362b6769fa3e24c76b1";
    hash = "sha256-3cNFP/k4JsgLyUQHWU10Htl2Rh0staAcA3R4piD6hDE=";
  };

  patches = [
    # https://github.com/thoughtpolice/yosys-bluespec/pull/14
    (fetchpatch {
      name = "fix-build-with-yosys-0.71.patch";
      url = "https://github.com/thoughtpolice/yosys-bluespec/pull/14/commits/237f62881999c20dc01b494348692c83ff4f432d.patch";
      hash = "sha256-mvLHomdenoUpJ5SR9rQbR+mlodz/N0BTFugkU0Q9YR4=";
    })
  ];

  # yosys >=0.67 headers require C++20; the Makefile otherwise pins c++17.
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '-std=c++17' '-std=c++20'
  '';

  buildInputs = [
    yosys
    readline
    zlib
    bluespec
  ];
  nativeBuildInputs = [ pkg-config ];

  doCheck = true;
  makeFlags = [
    "PREFIX=$(out)/share/yosys/plugins"
    "STATIC_BSC_PATH=${bluespec}/bin/bsc"
    "STATIC_BSC_LIBDIR=${bluespec}/lib"
  ];

  meta = {
    description = "Bluespec plugin for Yosys";
    homepage = "https://github.com/thoughtpolice/yosys-bluespec";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thoughtpolice ];
  };
}
