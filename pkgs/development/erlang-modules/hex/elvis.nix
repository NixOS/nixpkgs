{ buildErlang, fetchgit, lager, getopt, meck, jiffy, ibrowse, aleppo, zipper, erlang-github, erlang-katana }:

buildErlang {
  name = "elvis";
  version = "0.1";
  src = fetchgit {
    url = "git://github.com/inaka/elvis.git";
    sha256 = "1qvz4bmh307avjsxmhhdf35dd5wzmii0cbf6jyvvlhhkq4y0nmnj";
  };

  erlangDeps = [ lager getopt meck jiffy ibrowse aleppo zipper erlang-github erlang-katana ];
}