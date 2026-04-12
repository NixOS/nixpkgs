{
  lib,
  mkGendarmeEncoder,
  ppx_marshal_ext,
  yaml,
}:

mkGendarmeEncoder {
  propagatedBuildInputs = [
    ppx_marshal_ext
    yaml
  ];

  meta.description = "Marshal OCaml data structures to YAML";
}
