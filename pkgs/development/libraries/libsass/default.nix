{ lib, stdenv, fetchFromGitHub, autoreconfHook
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsass";
  version = "3.6.6"; # also check sassc for updates

  src = fetchFromGitHub {
    owner = "sass";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-FkLL3OAJXDptRQY6ZkYbss2pcc40f/wasIvEIyHRQFo=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/e2e/unicode-pwd
    '';
  };

  preConfigure = ''
    export LIBSASS_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = "https://github.com/sass/libsass";
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel offline ];
    pkgConfigModules = [ "libsass" ];
    platforms = platforms.unix;
  };
})
