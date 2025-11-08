{
  # allow overriding electron
  electron_37,
  webcord,
  replaceVars,
  lib,
  vencord-web-extension,
}:

# nixpkgs-update: no auto update
(webcord.override { inherit electron_37; }).overrideAttrs (old: {
  pname = "webcord-vencord";

  patches = (old.patches or [ ]) ++ [
    (replaceVars ./add-extension.patch {
      vencord = vencord-web-extension;
    })
  ];

  meta = {
    inherit (old.meta) license mainProgram platforms;

    description = "Webcord with Vencord web extension";
    maintainers = with lib.maintainers; [
      FlafyDev
      NotAShelf
    ];
  };
})
