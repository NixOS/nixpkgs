args @ { fetchurl, ... }:
{
  baseName = ''lack-middleware-backtrace'';
  version = ''lack-20190521-git'';

  description = ''System lacks description'';

  deps = [ args."uiop" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/lack/2019-05-21/lack-20190521-git.tgz'';
    sha256 = ''0ng1k5jq7icfi8c8r3wqj3qrqkh2lyav5ab6mf3l5y4bfwbil593'';
  };

  packageName = "lack-middleware-backtrace";

  asdFilesToKeep = ["lack-middleware-backtrace.asd"];
  overrides = x: x;
}
/* (SYSTEM lack-middleware-backtrace DESCRIPTION System lacks description
    SHA256 0ng1k5jq7icfi8c8r3wqj3qrqkh2lyav5ab6mf3l5y4bfwbil593 URL
    http://beta.quicklisp.org/archive/lack/2019-05-21/lack-20190521-git.tgz MD5
    7d7321550f0795e998c7afe4498e7a40 NAME lack-middleware-backtrace FILENAME
    lack-middleware-backtrace DEPS ((NAME uiop FILENAME uiop)) DEPENDENCIES
    (uiop) VERSION lack-20190521-git SIBLINGS
    (lack-component lack-middleware-accesslog lack-middleware-auth-basic
     lack-middleware-csrf lack-middleware-mount lack-middleware-session
     lack-middleware-static lack-request lack-response lack-session-store-dbi
     lack-session-store-redis lack-test lack-util-writer-stream lack-util lack
     t-lack-component t-lack-middleware-accesslog t-lack-middleware-auth-basic
     t-lack-middleware-backtrace t-lack-middleware-csrf t-lack-middleware-mount
     t-lack-middleware-session t-lack-middleware-static t-lack-request
     t-lack-session-store-dbi t-lack-session-store-redis t-lack-util t-lack)
    PARASITES NIL) */
