args @ { fetchurl, ... }:
rec {
  baseName = ''uiop'';
  version = ''3.2.0'';

  description = '''';

  deps = [ ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/uiop/2017-01-24/uiop-3.2.0.tgz'';
    sha256 = ''1rrn1mdcb4dmb517vrp3nzwpp1w8hfvpzarj36c7kkpjq23czdig'';
  };
}
