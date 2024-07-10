{ generateSplicesForMkScope, makeScopeWithSplicing' }:
let
  budgiePlugins =
    self:
    let
      inherit (self) callPackage;
    in
    {
      budgie-analogue-clock-applet = callPackage ./budgie-analogue-clock-applet { };
      budgie-media-player-applet = callPackage ./budgie-media-player-applet { };
      budgie-user-indicator-redux = callPackage ./budgie-user-indicator-redux { };
    };
in
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "budgiePlugins";
  f = budgiePlugins;
}
