{stdenv, buildOcaml, fetchurl, async_p4, core_p4, core_extended_p4}:

buildOcaml rec {
  name = "async_shell";
  version = "109.28.03";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_shell/archive/${version}.tar.gz";
    sha256 = "0b4497bea9124c5a665ee58fb0a73c5cbf2f757479df902e6870627196e6c105";
  };

  propagatedBuildInputs = [ async_p4 core_p4 core_extended_p4 ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_shell;
    description = "Shell helpers for Async";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
