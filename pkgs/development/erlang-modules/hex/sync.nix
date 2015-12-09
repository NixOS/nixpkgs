{ buildErlang, fetchgit }:

buildErlang {
  name = "sync";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/inaka/sync.git";
    sha256 = "0w4yhrnz4ncq67ka0dg2gj77pa0lqhbckv9zdrabfnkyan232cqp";
  };
}