{ lib
, stdenv
, fetchurl
, autoconf
, automake115x
, # this also disables building tests.
  # on static windows cross-compile they fail to build
  doCheck ? with stdenv.hostPlatform; !(isWindows && isStatic)
}:

stdenv.mkDerivation rec {
  pname = "libconfig";
  version = "1.7.3";

  src = fetchurl {
    url = "https://hyperrealm.github.io/${pname}/dist/${pname}-${version}.tar.gz";
    sha256 = "sha256-VFFm1srAN3RDgdHpzFpUBQlOe/rRakEWmbz/QLuzHuc=";
  };

  inherit doCheck;

  # upstream https://github.com/hyperrealm/libconfig/pull/190.
  # patch can be removed on next version
  patches = lib.optionals (!doCheck) [ ./disable-tests-option.patch ];
  # need these to generate files after applying the patch
  nativeBuildInputs = lib.optionals (!doCheck) [ autoconf automake115x ];

  configureFlags = lib.optional stdenv.hostPlatform.isWindows "--disable-examples"
    ++ lib.optional (!doCheck) "--disable-tests";

  cmakeFlags = lib.optionals (!doCheck) [ "-DBUILD_TESTS:BOOL=OFF" ];

  meta = with lib; {
    homepage = "http://www.hyperrealm.com/libconfig";
    description = "A simple library for processing structured configuration files";
    license = licenses.lgpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.all;
  };
}
