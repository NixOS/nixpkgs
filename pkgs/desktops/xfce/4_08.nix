{ pkgs, newScope }: let

common = (import ./common.nix) { inherit pkgs newScope xfce_self; };
callPackage = common.callPackage;

xfce_self = common.xfce_common // rec { # the lines are very long but it seems better than the even-odd line approach

  #### CORE

  exo           = callPackage ./core/exo.nix                { v= "0.6.2"; h= "0f8zh5y057l7xffskjvky6k88hrnz6jyk35mvlfpmx26anlgd77l"; };
  libxfce4ui    = callPackage ./core/libxfce4ui.nix         { v= "4.8.1"; h= "0mlrcr8rqmv047xrb2dbh7f4knsppb1anx2b05s015h6v8lyvjrr"; };
  libxfce4util  = callPackage ./core/libxfce4util.nix       { v= "4.8.2"; h= "05n8586h2fwkibfld5fm4ygx1w66jnbqqb3li0ardjvm2n24k885"; };
  libxfcegui4   = callPackage ./core/libxfcegui4.nix        { v= "4.8.1"; h= "0hr4h6a9p6w3qw1976p8v9c9pwhd9zhrjlbaph0p7nyz7j1836ih"; };
  thunar        = callPackage ./core/thunar.nix             { v= "1.2.3"; h= "19mczys6xr683r68g3s2njrrmnk1p73zypvwrhajw859c6nsjsp6"; };
  xfce4panel    = callPackage ./core/xfce4-panel.nix        { v= "4.8.6"; h= "00zdkg1jg4n2n109nxan8ji2m06r9mc4lnlrvb55xvj229m2dwb6"; };
  xfce4session  = callPackage ./core/xfce4-session.nix      { v= "4.8.2"; h= "1l608kik98jxbjl73waf8515hzji06lr80qmky2qlnp0b6js5g1i"; };
  xfce4settings = callPackage ./core/xfce4-settings.nix     { v= "4.8.3"; h= "0bmw0s6jp2ws4n0f3387zwsyv46b0w89m6r70yb7wrqy9r3wqy6q"; };
  xfceutils     = callPackage ./core/xfce-utils.nix         { v= "4.8.3"; h= "09mr0amp2f632q9i3vykaa0x5nrfihfm9v5nxsx9vch8wvbp0l03"; };
  xfconf        = callPackage ./core/xfconf.nix             { v= "4.8.1"; h= "1jwkb73xcgqfly449jwbn2afiyx50p150z60x19bicps75sp6q4q"; };
  xfdesktop     = callPackage ./core/xfdesktop.nix          { v= "4.8.3"; h= "097lc9djmay0jyyl42jmvcfda75ndp265nzn0aa3hv795bsn1175"; };
  xfwm4         = callPackage ./core/xfwm4.nix              { v= "4.8.3"; h= "0zi2g1d2jdgw5armlk9xjh4ykmydy266gdba86nmhy951gm8n3hb"; };

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix  { v= "4.8.0"; h= "0zy7i9x4qjchmyb8nfpb7m2ply5n2aq35p9wrhb8lpz4am1ihx7x"; };

  #### APPLICATIONS

  terminal      = null; # newer versions don't build with 4.8

    # versions > 0.3* don't build with xfce-4.8.*
  ristretto     = callPackage ./applications/ristretto.nix    { v= "0.3.7"; h= "19mzy159j4qhd7pd1b83gimxfdg3mwdab9lq9kk505d21r7iqc9b"; };

  xfce4mixer    = callPackage ./applications/xfce4-mixer.nix  { v= "4.8.0"; h= "1aqgjxvck6hx26sk3n4n5avhv02vs523mfclcvjb3xnks3yli7wz"; };

}; # xfce_self

in xfce_self

