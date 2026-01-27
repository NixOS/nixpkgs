{
  lib,
  mkGendarmeEncoder,
  ppx_marshal_ext,
  yojson,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    ppx_marshal_ext
    yojson
  ];

  meta.description = "Marshal OCaml data structures to JSON using Yojson";
}
