{
  swig,
  pcre,
  fetchFromGitHub,
}:

## for updating to SWIG 4, see
## https://github.com/GeraldWodni/swig/pull/6
(swig.overrideAttrs (old: {
  version = "3.0.9-forth";
  src = fetchFromGitHub {
    owner = "GeraldWodni";
    repo = "swig";
    rev = "a45b807e5f9d8ca1a43649c8265d2741a393862a";
    sha256 = "sha256-6nOOPFGFNaQInEkul0ZAh+ks9n3wqCQ6/tbduvG/To0=";
  };
  configureFlags = old.configureFlags ++ [ "--enable-forth" ];
})).override
  { pcre2 = pcre; }
