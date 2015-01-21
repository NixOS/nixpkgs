{
  "bundix" = {
    version = "0.1.0";
    source = {
      type = "git";
      url = "https://github.com/cstrahan/bundix.git";
      rev = "5df25b11b5b86e636754d54c2a8859c7c6ec78c7";
      fetchSubmodules = false;
      sha256 = "0334jsavpzkikcs7wrx7a3r0ilvr5vsnqd34lhc58b8cgvgll47p";
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
