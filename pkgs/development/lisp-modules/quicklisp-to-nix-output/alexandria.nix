args @ { fetchurl, ... }:
rec {
  baseName = ''alexandria'';
  version = ''20170227-git'';

  description = ''Alexandria is a collection of portable public domain utilities.'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/alexandria/2017-02-27/alexandria-20170227-git.tgz'';
    sha256 = ''0gnn4ysyvqf8wfi94kh6x23iwx3czaicam1lz9pnwsv40ws5fwwh'';
  };
}
