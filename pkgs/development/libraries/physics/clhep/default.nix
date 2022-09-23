{ lib
, stdenv
, fetchurl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "clhep";
  version = "2.4.5.3";

  src = fetchurl {
    url = "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-${version}.tgz";
    hash = "sha256-RfY+6wl/Av5nuGp9rb8Q1Am0AcKKGj4XLbNiUsMJfBM=";
  };

  prePatch = ''
    cd CLHEP
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "clhep_ensure_out_of_source_build()" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Set of HEP-specific foundation and utility classes such as random generators, physics vectors, geometry and linear algebra";
    homepage = "https://cern.ch/clhep";
    license = with licenses; [ gpl3Only lgpl3Only ];
    maintainers = with maintainers; [ veprbl ];
    platforms = platforms.unix;
  };
}
