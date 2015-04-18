{
  "bundix" = {
    version = "1.0.2";
    source = {
      type = "git";
      url = "https://github.com/cstrahan/bundix.git";
      rev = "e098b8c04087079c897aaf9542990e9fdd503bcf";
      sha256 = "0www8srjqlxy1pzn2b6himy5y768dni54m7rv67gj8yvx48vd803";
      fetchSubmodules = false;
    };
    dependencies = [
      "thor"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
}