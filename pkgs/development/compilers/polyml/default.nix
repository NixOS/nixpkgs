{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  libffi,
}:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "5.9.2";

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = "v${version}";
    sha256 = "sha256-dHP5XNoLcFIqASfZVWu3MtY3B3H66skEl8ohlwTGyyM=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'AC_FUNC_ALLOCA' "AC_FUNC_ALLOCA
    AH_TEMPLATE([_Static_assert])
    AC_DEFINE([_Static_assert], [static_assert])
    "
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure.ac --replace-fail stdc++ c++
  '';

  buildInputs = [
    libffi
    gmp
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-shared"
    "--with-system-libffi"
    "--with-gmp"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    make check
    runHook postCheck
  '';

  meta = with lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = "https://www.polyml.org/";
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [
      maggesi
      kovirobi
    ];
  };
}
