args @ { fetchurl, ... }:
rec {
  baseName = ''cl-paths-ttf'';
  version = ''cl-vectors-20150407-git'';

  description = ''cl-paths-ttf: vectorial paths manipulation'';

  deps = [ args."cl-paths" args."zpb-ttf" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz'';
    sha256 = ''1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w'';
  };

  overrides = x: {
  };
}
