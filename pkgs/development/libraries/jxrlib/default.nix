{ lib, stdenv, fetchFromGitHub, python3, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "jxrlib";
  version = "1.1";

  # Use the source from a fork on github because CodePlex does not
  # deliver an easily downloadable tarball.
  src = fetchFromGitHub {
    owner = "4creators";
    repo = pname;
    rev = "f7521879862b9085318e814c6157490dd9dbbdb4";
    sha256 = "0rk3hbh00nw0wgbfbqk1szrlfg3yq7w6ar16napww3nrlm9cj65w";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "cc" "$CC"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace '-shared' '-dynamiclib -undefined dynamic_lookup' \
      --replace '.so' '.dylib'
  '';

  nativeBuildInputs = [ python3 ] ++ lib.optional stdenv.isDarwin fixDarwinDylibNames;

  strictDeps = true;

  makeFlags = [ "DIR_INSTALL=$(out)" "SHARED=1" ];

  meta = with lib; {
    description = "Implementation of the JPEG XR image codec standard";
    homepage = "https://jxrlib.codeplex.com";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
