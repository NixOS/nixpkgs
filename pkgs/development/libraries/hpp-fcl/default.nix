{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-qeAO1FV28L2nbQ/2mDeLMuWS2+FexQ1ORCtt+ztWHj0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
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
  ] ++ lib.optionals (!pythonSupport) [
    "-DBUILD_PYTHON_INTERFACE=OFF"
  ];

  doCheck = true;
  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "hppfcl"
  ];

  meta = with lib; {
    description = "An extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
