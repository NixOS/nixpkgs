{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, testers

# for passthru.tests
, gtk3
, gtk4
, sassc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsass";
  version = "3.6.5"; # also check sassc for updates

  src = fetchFromGitHub {
    owner = "sass";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "1cxj6r85d5f3qxdwzxrmkx8z875hig4cr8zsi30w6vj23cyds3l2";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    postFetch = ''
      rm -r $out/test/e2e/unicode-pwd
    '';
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-26592.CVE-2022-43357.CVE-2022-43358.patch";
      url = "https://github.com/sass/libsass/pull/3184/commits/5bb0ea0c4b2ebebe542933f788ffacba459a717a.patch";
      hash = "sha256-DR6pKFWL70uJt//drzq34LeTzT8rUqgUTpgfUHpD2s4=";
    })
  ];

  preConfigure = ''
    export LIBSASS_VERSION=${finalAttrs.version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  passthru.tests = {
    inherit gtk3 gtk4 sassc;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = "https://github.com/sass/libsass";
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel offline ];
    pkgConfigModules = [ "libsass" ];
    platforms = platforms.unix;
  };
})
