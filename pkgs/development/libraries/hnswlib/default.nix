{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, python3
}:
let
  python = python3.withPackages(ps: with ps; [
    numpy
  ]);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "hnswlib";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "nmslib";
    repo = "hnswlib";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-XXz0NIQ5dCGwcX2HtbK5NFTalP0TjLO6ll6TmH3oflI=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-37365.patch";
      url = "https://github.com/nmslib/hnswlib/commit/f6d170ce0b41f9e75ace473b09df6e7872590757.patch";
      hash = "sha256-28nakC0rh6kx6yYjv7m6r9/yJ+lWQuooRFyYYQN2rX8=";
    })
  ];

  # this is a header-only library, so we don't need to build it
  # we need `cmake` only to run tests
  nativeBuildInputs = lib.optionals finalAttrs.doCheck [
    cmake
    python
  ];

  # we only want to run buildPhase when we run tests
  dontBuild = !finalAttrs.doCheck;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src/hnswlib/*.h -t $out/include/hnswlib

    runHook postInstall
  '';

  doCheck = true;

  preCheck = ''
    pushd ../tests/cpp
    ${python.interpreter} update_gen_data.py
    popd
  '';

  checkPhase = ''
    runHook preCheck

    ./test_updates

    runHook postCheck
  '';

  meta = with lib; {
    description = "Header-only C++/python library for fast approximate nearest neighbors";
    homepage = "https://github.com/nmslib/hnswlib";
    changelog = "https://github.com/nmslib/hnswlib/releases/tag/${finalAttrs.src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
    platforms = platforms.unix;
  };
})
