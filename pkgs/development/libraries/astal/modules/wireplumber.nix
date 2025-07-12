{ buildAstalModule, wireplumber }:
buildAstalModule {
  name = "wireplumber";
  buildInputs = [ wireplumber ];
  meta.description = "Astal module for wireplumber";
}
