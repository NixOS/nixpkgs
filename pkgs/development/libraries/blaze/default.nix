{
  lib,
  stdenv,
  fetchFromBitbucket,
  cmake,
  blas,
  lapack-reference,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blaze";
  version = "3.8.2";

  src = fetchFromBitbucket {
    owner = "blaze-lib";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jl9ZWFqBvLgQwCoMNX3g7z02yc7oYx+d6mbyLBzBJOs=";
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
