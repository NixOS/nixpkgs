{stdenv, buildOcamlJane, type_conv}:

buildOcamlJane {
  name = "variantslib";
  version = "113.33.03";

  minimumSupportedOcamlVersion = "4.00";

  hash = "1hv0f75msrryxsl6wfnbmhc0n8kf7qxs5f82ry3b8ldb44s3wigp";

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/janestreet/variantslib";
    description = "OCaml variants as first class values";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
