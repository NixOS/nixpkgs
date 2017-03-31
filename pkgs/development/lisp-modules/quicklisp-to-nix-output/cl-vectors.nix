args @ { fetchurl, ... }:
rec {
  baseName = ''cl-vectors'';
  version = ''20150407-git'';

  description = ''cl-paths: vectorial paths manipulation'';

  deps = [ args."cl-aa" args."cl-paths" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-vectors/2015-04-07/cl-vectors-20150407-git.tgz'';
    sha256 = ''1qd7ywc2ayiyd5nw7shnjgh0nc14h328h0cw921g5b2n8j6y959w'';
  };

  overrides = x: {
  };
}
