{ buildErlang, fetchgit }:

buildErlang {
  name = "jiffy";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/davisp/jiffy.git";
    sha256 = "02qb8m4s2p51m5f882ifsaph9fwx0bih37q5q90ba8cvsak65isx";
  };
}