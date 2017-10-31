{stdenv, buildOcamlJane, fetchurl, core_kernel,
 bin_prot, fieldslib,
 sexplib, herelib, opam, js_build_tools, ocaml_oasis}:

buildOcamlJane rec {
  name = "async_kernel";
  hash = "1n6ifbrq6q6hq8bxh6b9vhg11mv9r6jgp1b7vfw7mh5s2nrd4b60";
  propagatedBuildInputs = [ core_kernel bin_prot fieldslib herelib sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/async_kernel;
    description = "Jane Street Capital's asynchronous execution library (core) ";
    license = licenses.asl20;
    maintainers = [ maintainers.maurer maintainers.ericbmerritt ];
  };
}
