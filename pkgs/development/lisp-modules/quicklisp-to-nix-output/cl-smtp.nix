args @ { fetchurl, ... }:
rec {
  baseName = ''cl-smtp'';
  version = ''20160825-git'';

  description = ''Common Lisp smtp client.'';

  deps = [ args."cl+ssl" args."cl-base64" args."flexi-streams" args."trivial-gray-streams" args."usocket" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-smtp/2016-08-25/cl-smtp-20160825-git.tgz'';
    sha256 = ''0svkvy6x458a7rgvp3wki0lmhdxpaa1j0brwsw2mlpl2jqkx5dxh'';
  };

  overrides = x: {
  };
}
