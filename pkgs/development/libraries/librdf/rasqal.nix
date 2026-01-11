{
  lib,
  stdenv,
  fetchurl,
  librdf_raptor2,
  gmp,
  pkg-config,
  libxml2,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rasqal";
  version = "0.9.33";

  src = fetchurl {
    url = "http://download.librdf.org/source/rasqal-${finalAttrs.version}.tar.gz";
    sha256 = "0z6rrwn4jsagvarg8d5zf0j352kjgi33py39jqd29gbhcnncj939";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gmp
    libxml2
  ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  confiugureFlags = [
    # uses 'regex.h' as a fallback, which is preferrable
    "--disable-pcre"
  ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  nativeCheckInputs = [ perl ];
  doCheck = false; # fails with "No testsuite plan file sparql-query-plan.ttl could be created in build/..."
  doInstallCheck = false; # fails with "rasqal-config does not support (--help|--version)"

  passthru.tests = {
    # rasqal-config --version just checks the pkg-config module.
    # That check is broken, checking the pkg-config ourselves is a good replacement.
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "https://librdf.org/rasqal";
    license = with lib.licenses; [
      lgpl21
      asl20
    ];
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "rasqal" ];
  };
})
