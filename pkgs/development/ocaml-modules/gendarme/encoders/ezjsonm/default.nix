{
  lib,
  mkGendarmeEncoder,
  ezjsonm,
  ppx_marshal_ext,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    ezjsonm
    ppx_marshal_ext
  ];

  meta.description = "Marshal OCaml data structures to JSON using Ezjsonm";
}
