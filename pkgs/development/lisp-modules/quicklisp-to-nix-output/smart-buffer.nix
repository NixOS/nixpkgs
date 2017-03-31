args @ { fetchurl, ... }:
rec {
  baseName = ''smart-buffer'';
  version = ''20160628-git'';

  description = ''Smart octets buffer'';

  deps = [ args."flexi-streams" args."uiop" args."xsubseq" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/smart-buffer/2016-06-28/smart-buffer-20160628-git.tgz'';
    sha256 = ''1wp50snkc8739n91xlnfnq1dzz3kfp0awgp92m7xbpcw3hbaib1s'';
  };

  overrides = x: {
  };
}
