{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  yosys,
  readline,
  zlib,
  ghdl,
}:

stdenv.mkDerivation {
  pname = "yosys-ghdl";
  # This is not the latest commit, but it's the latest that builds with current stable ghdl 2.0.0
  version = "2022.01.11";
  plugin = "ghdl";

  src = fetchFromGitHub {
    owner = "ghdl";
    repo = "ghdl-yosys-plugin";
    rev = "c9b05e481423c55ffcbb856fd5296701f670808c";
    sha256 = "sha256-tT2+DXUtbJIBzBUBcyG2sz+3G+dTkciLVIczcRPr0Jw=";
  };

  buildInputs = [
    yosys
    readline
    zlib
    ghdl
  ];
  nativeBuildInputs = [
    pkg-config
  ];

  doCheck = true;
  installPhase = ''
    mkdir -p $out/share/yosys/plugins
    cp ghdl.so $out/share/yosys/plugins/ghdl.so
  '';

  meta = with lib; {
    description = "GHDL plugin for Yosys";
    homepage = "https://github.com/ghdl/ghdl-yosys-plugin";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
