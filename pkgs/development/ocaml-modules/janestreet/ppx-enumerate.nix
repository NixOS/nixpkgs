{stdenv, buildOcamlJane,
 ppx_core, ppx_tools, ppx_type_conv}:

buildOcamlJane rec {
  name = "ppx_enumerate";
  hash = "0m11921q2pjzkwckf21fynd2qfy83n9jjsgks23yagdai8a7ym16";
  propagatedBuildInputs = [ ppx_core ppx_tools ppx_type_conv ];

  meta = with stdenv.lib; {
    description = "Generate a list containing all values of a finite type";
    maintainers = [ maintainers.maurer ];
    license = licenses.asl20;
  };
}
