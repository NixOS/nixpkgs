{ buildErlang, fetchgit }:

buildErlang {
  name = "appmon";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/erlang-labs/appmon.git";
    sha256 = "12mra5y351xgvqywcw9pqr24y1rq848lrcbq9qm1swxz5bgi6b2q";
  };
}