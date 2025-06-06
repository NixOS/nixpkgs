{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgreen";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "cgreen-devs";
    repo = "cgreen";
    rev = finalAttrs.version;
    sha256 = "sha256-qcOj+NlgbHCYuNsM6ngNI2fNhkCwLL6mIVkNSv9hRE8=";
  };

  postPatch = ''
    for F in tools/discoverer_acceptance_tests.c tools/discoverer.c; do
      substituteInPlace "$F" --replace "/usr/bin/nm" "nm"
    done
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/cgreen-devs/cgreen";
    description = "Modern Unit Test and Mocking Framework for C and C++";
    mainProgram = "cgreen-runner";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
