{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
<<<<<<< HEAD
  version = "18.6.1";
  hash = "sha256-Jtjy2qmlm7zsl0a8o4/4jWdnse1yFR++oq3FcDuQOJo=";
  vendorHash = "sha256-PW8UP1YuUssw//1qb3oUN/FrbLUwt6D+c4q6jrm09Xk=";
  pnpmHash = "sha256-xjAqyReWRdty67LWaNX1jG4/uCeQtUMH/BKLIHUx6+0=";
=======
  version = "18.3.2";
  hash = "sha256-BeYn/uq81t9aL3xfxc7TJlNhvqJ2MDzN2Cue2XeG7g8=";
  vendorHash = "sha256-FSG/54vVFVWiJmlUYqS+3l2EoqxM9tUH91/Nap1p8nk=";
  pnpmHash = "sha256-6sThtwACNEdV0fleaQf3iMmFxPsd0AshYeYZUatFMcg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
