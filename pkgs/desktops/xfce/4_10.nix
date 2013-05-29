{ pkgs, newScope }: let

common = (import ./common.nix) { inherit pkgs newScope xfce_self; };
callPackage = common.callPackage;

xfce_self = common.xfce_common // rec { # the lines are very long but it seems better than the even-odd line approach

  #### CORE

  exo             = callPackage ./core/exo.nix              { v= "0.10.2"; h= "1kknxiz703q4snmry65ajm26jwjslbgpzdal6bd090m3z25q51dk"; };
  libxfce4ui      = callPackage ./core/libxfce4ui.nix       { v= "4.10.0"; h= "1qm31s6568cz4c8rl9fsfq0xmf7pldxm0ki62gx1cpybihlgmfd2"; };
  libxfce4util    = callPackage ./core/libxfce4util.nix     { v= "4.10.0"; h= "13k0wwbbqvdmbj4xmk4nxdlgvrdgr5y6r3dk380mzfw053hzwy89"; };
  libxfcegui4     = callPackage ./core/libxfcegui4.nix      { v= "4.10.0"; h= "0cs5im0ib0cmr1lhr5765yliqjfyxvk4kwy8h1l8bn3mj6bzk0ib"; };
  thunar          = callPackage ./core/thunar.nix           { v= "1.6.2";  h= "11dx38rvkfbp91pxrprymxhimsm90gvizp277x9s5rwnwcm1ggbx"; };
  xfce4panel      = callPackage ./core/xfce4-panel.nix      { v= "4.10.0"; h= "1f8903nx6ivzircl8d8s9zna4vjgfy0qhjk5d2x19g9bmycgj89k"; };
  xfce4session    = callPackage ./core/xfce4-session.nix    { v= "4.10.0"; h= "1kj65jkjhd0ysf0yxsf88wzpyv6n8i8qgd3gb502hf1x9jksk2mv"; };
  xfce4settings   = callPackage ./core/xfce4-settings.nix   { v= "4.10.0"; h= "0zppq747z9lrxyv5zrrvpalq7hb3gfhy9p7qbldisgv7m6dz0hq8"; };
  xfceutils       = null; # removed in 4.10
  xfconf          = callPackage ./core/xfconf.nix           { v= "4.10.0"; h= "0xh520z0qh0ib0ijgnyrgii9h5d4pc53n6mx1chhyzfc86j1jlhp"; };
  xfdesktop       = callPackage ./core/xfdesktop.nix        { v= "4.10.0"; h= "0yrddj1lgk3xn4w340y89z7x2isks72ia36pka08kk2x8gpfcyl9"; };
  xfwm4           = callPackage ./core/xfwm4.nix            { v= "4.10.0"; h= "170zzs7adj47srsi2cl723w9pl8k8awd7w1bpzxby7hj92zmf8s9"; };

  xfce4_appfinder = callPackage ./core/xfce4-appfinder.nix  { v= "4.9.4";  h= "12lgrbd1n50w9n8xkpai98s2aw8vmjasrgypc57sp0x0qafsqaxq"; };

  #### APPLICATIONS

  ristretto     = callPackage ./applications/ristretto.nix    { v= "0.6.3";  h= "0y9d8w1plwp4vmxs44y8k8x15i0k0xln89k6jndhv6lf57g1cs1b"; };
  terminal      = xfce4terminal; # it has changed its name
  xfce4mixer    = callPackage ./applications/xfce4-mixer.nix  { v= "4.10.0"; h= "1pnsd00583l7p5d80rxbh58brzy3jnccwikbbbm730a33c08kid8"; };
  xfce4terminal = callPackage ./applications/terminal.nix     { v= "0.6.1";  h= "1j6lpkq952mrl5p24y88f89wn9g0namvywhma639xxsswlkn8d31"; };

};

in xfce_self

