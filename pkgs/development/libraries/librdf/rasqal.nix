{
  lib,
  stdenv,
  fetchurl,
  librdf_raptor2,
  gmp,
  pkg-config,
  pcre,
  libxml2,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "rasqal";
  version = "0.9.33";

  src = fetchurl {
    url = "http://download.librdf.org/source/rasqal-${version}.tar.gz";
    sha256 = "0z6rrwn4jsagvarg8d5zf0j352kjgi33py39jqd29gbhcnncj939";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gmp
    pcre
    libxml2
  ];

  propagatedBuildInputs = [ librdf_raptor2 ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  nativeCheckInputs = [ perl ];
  doCheck = false; # fails with "No testsuite plan file sparql-query-plan.ttl could be created in build/..."
  doInstallCheck = false; # fails with "rasqal-config does not support (--help|--version)"

  meta = with lib; {
    description = "Library that handles Resource Description Framework (RDF)";
    homepage = "https://librdf.org/rasqal";
    license = with licenses; [
      lgpl21
      asl20
    ];
    maintainers = with maintainers; [ marcweber ];
    platforms = platforms.unix;
  };
}
