{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {

  pname = "tracefilegen";
  version = "0-unstable-2017-05-13";

  src = fetchFromGitHub {
    owner = "GarCoSim";
    repo = "TraceFileGen";
    rev = "0ebfd1fdb54079d4bdeaa81fc9267ecb9f016d60";
    sha256 = "1gsx18ksgz5gwl3v62vgrmhxc0wc99i74qwhpn0h57zllk41drjc";
  };

  nativeBuildInputs = [ cmake ];

  patches = [ ./gcc7.patch ];

  installPhase = ''
    install -Dm755 TraceFileGen $out/bin/TraceFileGen
    mkdir -p $out/share/doc/${pname}-${version}/
    cp -ar $src/Documentation/html $out/share/doc/${pname}-${version}/.
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "Automatically generate all types of basic memory management operations and write into trace files";
    mainProgram = "TraceFileGen";
    homepage = "https://github.com/GarCoSim";
    maintainers = [ maintainers.cmcdragonkai ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
