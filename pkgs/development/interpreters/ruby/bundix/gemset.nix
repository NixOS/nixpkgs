{
  "bundix" = {
    version = "1.0.2";
    source = {
      type = "git";
      url = "https://github.com/cstrahan/bundix.git";
      rev = "c879cf901ff8084b4c97aaacfb5ecbdb0f95cc03";
      sha256 = "1v0mg5wq09bvdv2lf9gb7an2ak7i5jr3lrv23q0k0q122jb64zfv";
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
