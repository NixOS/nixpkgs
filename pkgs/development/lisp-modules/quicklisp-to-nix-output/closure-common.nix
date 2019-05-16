args @ { fetchurl, ... }:
rec {
  baseName = ''closure-common'';
  version = ''20181018-git'';

  description = '''';

  deps = [ args."alexandria" args."babel" args."trivial-features" args."trivial-gray-streams" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/closure-common/2018-10-18/closure-common-20181018-git.tgz'';
    sha256 = ''18bp7jnxma9hscp09fa723ws9nnynjil935rp8dy9hp6ypghpxpn'';
  };

  packageName = "closure-common";

  asdFilesToKeep = ["closure-common.asd"];
  overrides = x: x;
}
/* (SYSTEM closure-common DESCRIPTION NIL SHA256
    18bp7jnxma9hscp09fa723ws9nnynjil935rp8dy9hp6ypghpxpn URL
    http://beta.quicklisp.org/archive/closure-common/2018-10-18/closure-common-20181018-git.tgz
    MD5 b09ee60c258a29f0c107960ec4c04ada NAME closure-common FILENAME
    closure-common DEPS
    ((NAME alexandria FILENAME alexandria) (NAME babel FILENAME babel)
     (NAME trivial-features FILENAME trivial-features)
     (NAME trivial-gray-streams FILENAME trivial-gray-streams))
    DEPENDENCIES (alexandria babel trivial-features trivial-gray-streams)
    VERSION 20181018-git SIBLINGS NIL PARASITES NIL) */
