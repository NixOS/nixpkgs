args @ { fetchurl, ... }:
rec {
  baseName = ''query-fs'';
  version = ''20160531-git'';

  description = ''High-level virtual FS using CL-Fuse-Meta-FS to represent results of queries'';

  deps = [ args."bordeaux-threads" args."cl-fuse" args."cl-fuse-meta-fs" args."cl-ppcre" args."command-line-arguments" args."iterate" args."trivial-backtrace" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/query-fs/2016-05-31/query-fs-20160531-git.tgz'';
    sha256 = ''0wknr3rffihg1my8ihmpwssxpxj4bfmqcly0s37q51fllxkr1v5a'';
  };

  overrides = x: {
  };
}
