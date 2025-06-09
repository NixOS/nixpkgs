{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unity-test";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "ThrowTheSwitch";
    repo = "Unity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g0ubq7RxGQmL1R6vz9RIGJpVWYsgrZhsTWSrL1ySEug=";
  };

  nativeBuildInputs = [ cmake ];
  doCheck = true;

  meta = {
    description = "Unity Unit Testing Framework";
    homepage = "https://www.throwtheswitch.org/unity";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.i01011001 ];
  };
})
