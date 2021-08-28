{ lib, runCommandNoCC, powerline }:

let
  inherit (powerline) version;
in runCommandNoCC "powerline-symbols-${version}" {
  meta = {
    inherit (powerline.meta) license;
    priority = (powerline.meta.priority or 0) + 1;
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
