{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  # passthru.tests
  tmux,
  fcft,
  arrow-cpp,
<<<<<<< HEAD
  enableStatic ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "utf8proc";
  version = "2.11.2";
=======
}:

stdenv.mkDerivation rec {
  pname = "utf8proc";
  version = "2.11.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "JuliaStrings";
    repo = "utf8proc";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-/+/IrsLQ9ykuVOaItd2ZbX60pPlP2omvS1qJz51AnWA=";
=======
    rev = "v${version}";
    hash = "sha256-fFeevzek6Oql+wMmkZXVzKlDh3wZ6AjGCKJFsXBaqzg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
<<<<<<< HEAD
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
    (lib.cmakeBool "UTF8PROC_ENABLE_TESTING" finalAttrs.finalPackage.doCheck)
=======
    "-DBUILD_SHARED_LIBS=ON"
    "-DUTF8PROC_ENABLE_TESTING=ON"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doCheck = true;

  passthru.tests = {
    inherit fcft tmux arrow-cpp;
  };

<<<<<<< HEAD
  meta = {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [
      lib.maintainers.ftrvxmtrx
      lib.maintainers.sternenseemann
    ];
  };
})
=======
  meta = with lib; {
    description = "Clean C library for processing UTF-8 Unicode data";
    homepage = "https://juliastrings.github.io/utf8proc/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [
      maintainers.ftrvxmtrx
      maintainers.sternenseemann
    ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
