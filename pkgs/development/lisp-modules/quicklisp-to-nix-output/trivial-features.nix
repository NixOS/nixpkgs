args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-features'';
  version = ''20161204-git'';

  description = ''Ensures consistent *FEATURES* across multiple CLs.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-features/2016-12-04/trivial-features-20161204-git.tgz'';
    sha256 = ''0i2zyc9c7jigljxll29sh9gv1fawdsf0kq7s86pwba5zi99q2ij2'';
  };

  overrides = x: {
  };
}
