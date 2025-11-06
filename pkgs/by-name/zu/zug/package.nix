{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  catch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zug";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "zug";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ti0EurhGQgWSXzSOlH9/Zsp6kQ/+qGjWbfHGTPpfehs=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/arximboldi/zug/commit/c8c74ada30d931e40636c13763b892f20d3ce1ae.patch";
      hash = "sha256-0x+ScRnziBeyHWYJowcVb2zahkcK2qKrMVVk2twhtHA=";
    })
  ];

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
    maintainers = with lib.maintainers; [ nek0 ];
    license = lib.licenses.boost;
  };
})
