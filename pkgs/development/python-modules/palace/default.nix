{
  lib,
  buildPythonPackage,
  fetchFromSourcehut,
  cmake,
  cython_0,
  setuptools,
  alure2,
}:

buildPythonPackage rec {
  pname = "palace";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = "palace";
    rev = version;
    sha256 = "1z0m35y4v1bg6vz680pwdicm9ssryl0q6dm9hfpb8hnifmridpcj";
  };

  # Nix uses Release CMake configuration instead of what is assumed by palace.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail IMPORTED_LOCATION_NOCONFIG IMPORTED_LOCATION_RELEASE \
      --replace-fail "cmake_minimum_required(VERSION 2.6.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  build-system = [
    cmake
    cython_0
    setuptools
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ alure2 ];

  doCheck = false; # FIXME: tests need an audio device

  pythonImportsCheck = [ "palace" ];

  meta = {
    description = "Pythonic Audio Library and Codecs Environment";
    homepage = "https://mcsinyx.gitlab.io/palace";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.McSinyx ];
  };
}
