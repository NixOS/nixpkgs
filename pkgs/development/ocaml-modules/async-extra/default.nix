{stdenv, buildOcaml, fetchurl, async-kernel, async-unix,
 bin-prot, core, custom-printf, fieldslib, herelib, pa-ounit,
 pipebang, pa-test, sexplib}:

buildOcaml rec {
  name = "async-extra";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/async_extra/archive/${version}.tar.gz";
    sha256 = "51f6f67a9ad56fe5dcf09faeeca6ec2fea53a7a975a72bc80504b90841212e28";
  };

  buildInputs = [ pa-test pa-ounit ];
  propagatedBuildInputs = [ async-kernel async-unix core bin-prot custom-printf
                            fieldslib herelib pipebang sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_extra;
    description = "Jane Street Capital's asynchronous execution library (extra)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
