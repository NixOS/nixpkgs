{
  lib,
  buildPythonPackage,
  python,
  pythonOlder,
  fetchFromGitHub,
  cmake,
  sip4,
  distutils,
}:

buildPythonPackage rec {
  pname = "libsavitar";
  version = "4.12.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "libSavitar";
    rev = version;
    hash = "sha256-MAA1WtGED6lvU6N4BE6wwY1aYaFrCq/gkmQFz3VWqNA=";
  };

  postPatch = ''
    sed -i 's#''${Python3_SITEARCH}#${placeholder "out"}/${python.sitePackages}#' cmake/SIPMacros.cmake

    substituteInPlace pugixml/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.6)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    sip4
  ];

  propagatedBuildInputs = [
    sip4
    distutils
  ];

  strictDeps = true;

  meta = {
    description = "C++ implementation of 3mf loading with SIP python bindings";
    homepage = "https://github.com/Ultimaker/libSavitar";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
