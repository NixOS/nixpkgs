args @ { fetchurl, ... }:
rec {
  baseName = ''trivial-backtrace'';
  version = ''20160531-git'';

  description = ''trivial-backtrace'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz'';
    sha256 = ''1vcvalcv2ljiv2gyh8xjcg62cjsripjwmnhc8zji35ja1xyqvxhx'';
  };

  packageName = "trivial-backtrace";

  asdFilesToKeep = ["trivial-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM trivial-backtrace DESCRIPTION trivial-backtrace SHA256
    1vcvalcv2ljiv2gyh8xjcg62cjsripjwmnhc8zji35ja1xyqvxhx URL
    http://beta.quicklisp.org/archive/trivial-backtrace/2016-05-31/trivial-backtrace-20160531-git.tgz
    MD5 a3b41b4ae24e3fde303a2623201aac4d NAME trivial-backtrace FILENAME
    trivial-backtrace DEPS NIL DEPENDENCIES NIL VERSION 20160531-git SIBLINGS
    (trivial-backtrace-test) PARASITES NIL) */
