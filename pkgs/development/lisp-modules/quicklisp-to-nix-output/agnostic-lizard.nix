{ fetchurl }:
rec {
  baseName = ''agnostic-lizard'';
  version = ''20170227-git'';

  description = ''A portable code walker that makes a best effort to be correct in most cases'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/agnostic-lizard/2017-02-27/agnostic-lizard-20170227-git.tgz'';
    sha256 = ''0gnbxfdz35z9kznnhnj9x5zzn25k1x2ifv4v9rkzb0xmi7xkx9wi'';
  };
}
