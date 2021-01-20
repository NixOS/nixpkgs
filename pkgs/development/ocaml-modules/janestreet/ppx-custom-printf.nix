{lib, buildOcamlJane,
 ppx_core, ppx_driver, ppx_sexp_conv, ppx_tools}:

buildOcamlJane {
  name = "ppx_custom_printf";
  hash = "06y85m6ky376byja4w7gdwd339di5ag0xrf0czkylzjsnylhdr85";

  propagatedBuildInputs = [ ppx_core ppx_driver ppx_sexp_conv ppx_tools ];

  meta = with lib; {
    description = "Extensions to printf-style format-strings for user-defined string conversion";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
