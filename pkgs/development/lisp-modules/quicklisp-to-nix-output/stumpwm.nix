args @ { fetchurl, ... }:
rec {
  baseName = ''stumpwm'';
  version = ''20170227-git'';

  description = ''A tiling, keyboard driven window manager'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/stumpwm/2017-02-27/stumpwm-20170227-git.tgz'';
    sha256 = ''0w1arw1x5hsw0w6rc1ls4bf7gf8cjcm6ar68kp74zczp0y35fign'';
  };

  overrides = x: {
  };
}
