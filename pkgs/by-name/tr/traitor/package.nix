{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "traitor";
  version = "0.0.14";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "traitor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-LQfKdjZaTm5z8DUt6He/RJHbOUCUwP3CV3Fyt5rJIfU=";
  };

  vendorHash = null;

  meta = {
    description = "Automatic Linux privilege escalation";
    longDescription = ''
      Automatically exploit low-hanging fruit to pop a root shell. Traitor packages
      up a bunch of methods to exploit local misconfigurations and vulnerabilities
      (including most of GTFOBins) in order to pop a root shell.
    '';
    homepage = "https://github.com/liamg/traitor";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
