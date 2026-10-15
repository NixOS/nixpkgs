{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  catch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zug";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "zug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0HrvCpbVnxEvwvG4btXu0hRzdcHsGwM/HUWES/fmxrs=";
  };

  # this test assumes properties of a random sampling function, which no longer
  # holds after gcc 16's implementation of
  # "P0952R2: A new specification for std::generate_canonical"
  # https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2023/p0952r2.html
  # https://github.com/arximboldi/zug/issues/54
  #
  # zug plumbs in its test suite in very non-standard ways, making it annoying
  # to disable tests through standard ctest machinery. this appears to be the
  # easiest way.
  postPatch = ''
    substituteInPlace test/transducer/random_sample.cpp --replace-fail \
      'TEST_CASE("random_sample, simple")' \
      'TEST_CASE("random_sample, simple", "[.]")'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    catch2
  ];

  cmakeFlags = [ "-Dzug_BUILD_EXAMPLES=OFF" ];

  preConfigure = ''
    rm BUILD
  '';

  doCheck = true;

  meta = {
    homepage = "https://github.com/arximboldi/zug";
    description = "Library for functional interactive c++ programs";
    maintainers = [ ];
    license = lib.licenses.boost;
  };
})
