{
  lib,
  stdenv,
  libxml2,
  libxslt,
  fetchhg,
}:

# Upstream maintains documentation (sources of https://nginx.org) in separate
# mercurial repository, which do not correspond to particular git commit, but at
# least has "introduced in version X.Y" comments.
#
# In other words, documentation does not necessary matches capabilities of
# $out/bin/nginx, but we have no better options.
stdenv.mkDerivation {
  pname = "nginx-doc-unstable";
  version = "2022-05-05";
  src = fetchhg {
    url = "https://hg.nginx.org/nginx.org";
    rev = "a3aee2697d4e";
    sha256 = "029n4mnmjw94h01qalmjgf1c2h3h7wm798xv5knk3padxiy4m28b";
  };
  patches = [ ./exclude-google-analytics.patch ];
  nativeBuildInputs = [
    libxslt
    libxml2
  ];

  # Generated documentation is not local-friendly, since it assumes that link to directory
  # is the same as link to index.html in that directory, which is not how browsers behave
  # with local filesystem.
  #
  # TODO: patch all relative links that do not end with .html.

  # /en subdirectory must exist, relative links expect it.
  installPhase = ''
    mkdir -p $out/share/doc/nginx
    mv libxslt/en $out/share/doc/nginx
  '';

  meta = with lib; {
    description = "A reverse proxy and lightweight webserver (documentation)";
    homepage = "https://nginx.org/";
    license = licenses.bsd2;
    platforms = platforms.all;
    priority = 6;
    maintainers = with maintainers; [ kaction ];
  };
}
