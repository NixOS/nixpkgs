{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  libffi,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "5.7.1";

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

  patches = [
    ./5.7-new-libffi-FFI_SYSV.patch

    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/polyml/raw/4d8868ca5a1ce3268f212599a321f8011c950496/f/polyml-pthread-stack-min.patch";
      sha256 = "1h5ihg2sxld9ymrl3f2mpnbn2242ka1fsa0h4gl9h90kndvg6kby";
    })
  ];

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

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = "v${version}";
    sha256 = "0j0wv3ijfrjkfngy7dswm4k1dchk3jak9chl5735dl8yrl8mq755";
  };

  meta = with lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = "https://www.polyml.org/";
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    # never built on aarch64-darwin since first introduction in nixpkgs
    # The last successful Darwin Hydra build was in 2024
    broken = stdenv.hostPlatform.isDarwin;
  };
}
