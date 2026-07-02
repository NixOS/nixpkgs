{
  blas,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  pythonSupport ? false,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "trlib";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "felixlen";
    repo = "trlib";
    rev = finalAttrs.version;
    hash = "sha256-pD2MGsIQgMO4798Gp9oLprKhmV0lcjgtUHh1rvEjSIY=";
  };

  patches = [
    # update use of distutils
    # This PR was merged upstream, so the patch can be removed on next release
    (fetchpatch {
      name = "python312-support.patch";
      url = "https://github.com/felixlen/trlib/pull/26/commits/6b72f3b2afebee4ae179bc760f93b16c60fd72d8.patch";
      hash = "sha256-+6iiALFhMSiE44kpkDrhwrYt4miHlPkiffRZAgsM1Jo=";
    })
  ];

  # ref. https://github.com/felixlen/trlib/pull/25
  # This PR was merged upstream, so the patch can be removed on next release
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required (VERSION 3.1)" \
      "cmake_minimum_required (VERSION 3.13)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.cython
    python3Packages.numpy
  ];

  cmakeFlags = [ (lib.cmakeBool "TRLIB_BUILD_PYTHON3" pythonSupport) ];

  meta = {
    description = "Trust Region Subproblem Solver Library";
    homepage = "https://github.com/felixlen/trlib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
