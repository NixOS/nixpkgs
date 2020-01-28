{ lib, stdenv, fetchFromGitHub, cmake, gcc, boost, eigen, libxml2, openmpi, python3, python3Packages }:

stdenv.mkDerivation rec {
  pname = "precice";
  version = "2020-01-20";
  # Todo next release switch back to versioning but for python3 support master is needed

  src = fetchFromGitHub {
    owner = "precice";
    repo = pname;
    rev = "9f778290416416255fc73a495e962def301648b0";
    sha256 = "1ij43qjbf1aq3lh91gqpviajc8lyl7qkxfccmj5md5vwf88vjaip";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DPETSC=off"
    "-DPYTHON_LIBRARIES=${python3.libPrefix}"
    "-DPYTHON_INCLUDE_DIR=${python3}/include/${python3.libPrefix}m"
  ];

  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ boost eigen libxml2 openmpi python3 python3Packages.numpy ];
  patches = [
    ./0001-Fix-the-install-target-dirs-to-use-the-CMAKE-flags.patch # CMake Packaging is not perfect upstream, after this PR it is https://github.com/precice/precice/pull/577/files
  ];
  enableParallelBuilding = true;

  postInstall = ''
      substituteInPlace "$out"/lib/cmake/precice/preciceTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include;' 'INTERFACE_INCLUDE_DIRECTORIES "'$out/include';'
  ''; # Check if this can be removed after upstream PR 577

  meta = {
    description = "preCICE stands for Precise Code Interaction Coupling Environment";
    license = with lib.licenses; [ gpl3 ];
    homepage = "https://www.precice.org/";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Scriptkiddi ];
  };
}


