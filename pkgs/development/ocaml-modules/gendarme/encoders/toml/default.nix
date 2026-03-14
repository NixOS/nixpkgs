{
  lib,
  mkGendarmeEncoder,
  ppx_marshal_ext,
  toml,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    ppx_marshal_ext
    toml
  ];

  meta.description = "Marshal OCaml data structures to TOML";
}
