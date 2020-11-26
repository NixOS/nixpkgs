{ fetchFromGitLab }:

let
  # We need a gvc different then that which is shipped in the source tarball of
  # whatever package that imports this file
  gvc-src-with-ucm = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "libgnome-volume-control";
    rev = "7a621180b46421e356b33972e3446775a504139c";
    sha256 = "07rkgh9f7qcmlpy6jqh944axzh3z38f47g48ii842f2i3a1mrbw9";
  };
in
''
  rm -r ./subprojects/gvc
  cp -r ${gvc-src-with-ucm} ./subprojects/gvc
''
