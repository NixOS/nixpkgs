{ buildAstalModule, networkmanager }:
buildAstalModule {
  name = "network";
  buildInputs = [ networkmanager ];
  meta.description = "Astal module for NetworkManager";
}
