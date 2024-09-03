{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, eigen
, assimp
, octomap
, qhull
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-fcl";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0OORdtT7vMpvK3BPJvtvuLcz0+bfu1+nVvzs3y+LyQw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ] ++ lib.optionals pythonSupport [
    python3Packages.numpy
  ];

  propagatedBuildInputs = [
    assimp
    qhull
    octomap
  ] ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ];

  cmakeFlags = [
    "-DHPP_FCL_HAS_QHULL=ON"
    "-DINSTALL_DOCUMENTATION=ON"
  ] ++ lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

  doCheck = true;
  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "hppfcl"
  ];

  outputs = [ "dev" "out" "doc" ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/${finalAttrs.pname} "$dev"
  '';


  meta = with lib; {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
