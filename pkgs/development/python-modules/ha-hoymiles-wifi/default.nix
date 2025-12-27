{
  pkgs,
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  pname = "ha-hoymiles-wifi";
  owner = "suaveolent";
  domain = "hoymiles_wifi";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "suaveolent";
    repo = "ha-hoymiles-wifi";
    tag = "v${version}";
    hash = "sha256-6NxsnRAo8KjlKYfyqosdS0Q34j0KBNNRUWbZmQOvxJk=";
  };

  dependencies = [ pkgs.python3Packages.hoymiles_wifi ];

  meta = {
    changelog = "https://github.com/suaveolent/ha-hoymiles-wifi/releases/tag/${src.tag}";
    description = "Home Assistant custom component for Hoymiles DTUs and the HMS-XXXXW-2T microinverters";
    homepage = "https://github.com/suaveolent/ha-hoymiles-wifi";
    maintainers = with lib.maintainers; [ maximumstock ];
    license = lib.licenses.mit;
  };
}
