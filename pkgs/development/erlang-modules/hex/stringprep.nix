{ buildErlang, fetchgit }:

buildErlang {
  name = "stringprep";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/processone/stringprep.git";
    sha256 = "0q6xkywanh2wjjr0601pqh63qm08bq1firap7n3sdcfh0h0d9vnx";
  };
}