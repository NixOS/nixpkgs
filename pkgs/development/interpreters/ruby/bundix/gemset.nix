{
  "bundix" = {
    version = "1.0.2";
    source = {
      type = "git";
      url = "https://github.com/cstrahan/bundix.git";
      rev = "c879cf901ff8084b4c97aaacfb5ecbdb0f95cc03";
      sha256 = "05kmdnq4qa5h8l3asv05cjpnyplnqqx6hrqybj2cjlzmdxnkkgyj";
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