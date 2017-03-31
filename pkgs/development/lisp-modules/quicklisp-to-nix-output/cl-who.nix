args @ { fetchurl, ... }:
rec {
  baseName = ''cl-who'';
  version = ''1.1.4'';

  description = ''(X)HTML generation macros'';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cl-who/2014-12-17/cl-who-1.1.4.tgz'';
    sha256 = ''0r9wc92njz1cc7nghgbhdmd7jy216ylhlabfj0vc45bmfa4w44rq'';
  };

  overrides = x: {
  };
}
