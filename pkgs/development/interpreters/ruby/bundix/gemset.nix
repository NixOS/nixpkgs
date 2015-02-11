{
  "bundix" = {
    version = "0.1.0";
    source = {
      type = "git";
      url = "https://github.com/cstrahan/bundix.git";
      rev = "5df25b11b5b86e636754d54c2a8859c7c6ec78c7";
      fetchSubmodules = false;
      sha256 = "1iqx12y777v8gszggj25x0xcf6lzllx58lmv53x6zy3jmvfh4siv";
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
