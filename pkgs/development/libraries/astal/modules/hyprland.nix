{ buildAstalModule, json-glib }:
buildAstalModule {
  name = "hyprland";
  buildInputs = [ json-glib ];
  meta.description = "Astal module for Hyprland using IPC";
}
