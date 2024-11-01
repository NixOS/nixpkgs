{
  # allow overriding electron
  electron,
  webcord,
  substituteAll,
  lib,
  vencord-web-extension,
}:

# nixpkgs-update: no auto update
(webcord.override { inherit electron; }).overrideAttrs (old: {
  pname = "webcord-vencord";

  patches = (old.patches or [ ]) ++ [
    (substituteAll {
      src = ./add-extension.patch;
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
