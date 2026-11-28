{
  lib,
  mkGendarmeEncoder,
  csv,
  ppx_marshal_ext,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    csv
    ppx_marshal_ext
  ];

  meta.description = "Marshal OCaml data structures to CSV";
}
