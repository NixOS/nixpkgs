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
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-7MXQ5+S/lvaTBVGY2gTJ1nUegtf9cp7p0JLJ4oPJAUY=";
  };

  patches = [
    # Fix unittest where nix env set `boost::archive::tmpdir()` to `/build` and trigger a path concatenation bug.
    (fetchpatch {
      name = "tests-use-boost-filesystem.patch";
      url = "https://github.com/humanoid-path-planner/hpp-fcl/commit/7e8fde64a5d2c2412325f6cb5d78623bf2409176.patch";
      hash = "sha256-YjESkj8SqYiyrJuXIa5mSnHIph/D04J10poTDcYgs2c=";
    })
  ];

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
