{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, setuptools-scm
, absl-py
, lxml
, skia-pathops
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "picosvg";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jG1rfamegnX8GXDwqkGFBFzUeycRLDObJvGbxNk6OpM=";
  };

  patches = [
    # see https://github.com/googlefonts/picosvg/issues/299
    # this patch fixed a failing test case after the update to skia-pathops 0.8
    # as soon as skia-pathops in nixpkgs is updated to 0.8, this patch should be removed
    (fetchpatch {
      url = "https://github.com/googlefonts/picosvg/commit/4e971ed6cd9afb412b2845d29296a0c24f086562.patch";
      hash = "sha256-OZEipNPCSuuqcy4XggBiuGv4HN604dI4N9wlznyAwF0=";
      revert = true;
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    absl-py
    lxml
    skia-pathops
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # a few tests are failing on aarch64
  doCheck = !stdenv.isAarch64;

  meta = with lib; {
    description = "Tool to simplify SVGs";
    homepage = "https://github.com/googlefonts/picosvg";
    license = licenses.asl20;
    maintainers = with maintainers; [ _999eagle ];
  };
}
