{stdenv, buildOcaml, fetchurl, async_p4, core_p4, sexplib_p4}:

buildOcaml rec {
  name = "async_find";
  version = "111.28.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_find/archive/${version}.tar.gz";
    sha256 = "4e3fda72f50174f05d96a5a09323f236c041b1a685890c155822956f3deb8803";
  };

  propagatedBuildInputs = [ async_p4 core_p4 sexplib_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_find;
    description = "Directory traversal with Async";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
