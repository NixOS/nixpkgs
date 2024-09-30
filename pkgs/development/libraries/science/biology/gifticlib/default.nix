{ lib, stdenv, fetchFromGitHub, cmake, expat, nifticlib, zlib }:

stdenv.mkDerivation rec {
  pname = "gifticlib";
  version = "unstable-2020-07-07";

  src = fetchFromGitHub {
    owner = "NIFTI-Imaging";
    repo = "gifti_clib";
    rev = "5eae81ba1e87ef3553df3b6ba585f12dc81a0030";
    sha256 = "0gcab06gm0irjnlrkpszzd4wr8z0fi7gx8f7966gywdp2jlxzw19";
  };

  cmakeFlags = [ "-DUSE_SYSTEM_NIFTI=ON" "-DDOWNLOAD_TEST_DATA=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ expat nifticlib zlib ];

  # without the test data, this is only a few basic tests
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkPhase = ''
    runHook preCheck
    ctest -LE 'NEEDS_DATA'
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://www.nitrc.org/projects/gifti";
    description = "Medical imaging geometry format C API";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = licenses.publicDomain;
  };
}
