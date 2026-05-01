{
  src,
  raylib-python-cffi,
  writers,
}:
let
  writeTest =
    name: path:
    writers.writePython3Bin name {
      libraries = [ raylib-python-cffi ];
      doCheck = false;
    } (builtins.readFile (src + path));

in
{
  basic_shapes = writeTest "basic_shapes" "/examples/shapes/shapes_basic_shapes.py";

  cffi_binding =
    (writeTest "cffi_binding" "/tests/test_static_with_only_api_from_dynamic.py").overrideAttrs
      (prev: {
        buildCommand = prev.buildCommand + ''
          substituteInPlace $out/bin/cffi_binding \
            --replace-fail "examples/models/resources/heightmap.png" \
              "${src}/examples/models/resources/heightmap.png"
        '';
      });
}
