{ lib, runCommand, powerline }:

let
  inherit (powerline) version;
in runCommand "powerline-symbols-${version}" {
  meta = {
    inherit (powerline.meta) license;
    priority = (powerline.meta.priority or lib.meta.defaultPriority) + 1;
    maintainers = with lib.maintainers; [ midchildan ];
  };
} ''
  install -Dm644 \
    ${powerline.src}/font/PowerlineSymbols.otf \
    $out/share/fonts/OTF/PowerlineSymbols.otf
  install -Dm644 \
    ${powerline.src}/font/10-powerline-symbols.conf \
    $out/etc/fonts/conf.d/10-powerline-symbols.conf
''
