{ lib
, stdenv
, fetchFromBitbucket
, cmake
, blas
, lapack-reference
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blaze";
  version = "3.8.1";

  src = fetchFromBitbucket {
    owner = "blaze-lib";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-fe6J0aquk4j+b11Sq+ihagWA/LMTYnAgIHbaDCZacP0=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    lapack-reference
  ];

  meta = with lib; {
    description = "high performance C++ math library";
    homepage = "https://bitbucket.org/blaze-lib/blaze";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
})
