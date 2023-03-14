{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, symlinkJoin
}:

let p2 = buildGoModule rec {
  pname = "packr2";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = "packr";
    rev = "v${version}";
    sha256 = "1x78yq2yg0r82h7a67078llni85gk9nbd2ismlbqgppap7fcpyai";
  }+"/v2";

  subPackages = [ "packr2" ];

  vendorSha256 = "12yq121b0bn8z12091fyqhhz421kgx4z1nskrkvbxlhyc47bwyrp";

  doCheck = false;

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];

    # golang.org/x/sys needs to be updated due to:
    #
    #   https://github.com/golang/go/issues/49219
    #
    # but this package is no longer maintained.
    #
    broken = stdenv.isDarwin;
  };
};
p1 = buildGoModule rec {
  pname = "packr1";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = "packr";
    rev = "v${version}";
    sha256 = "1x78yq2yg0r82h7a67078llni85gk9nbd2ismlbqgppap7fcpyai";
  };

  subPackages = [ "packr" ];

  vendorSha256 = "0m3yj8ww4a16j56p8d8w0sdnyx0g2bkd8zg0l4d8vb72mvg5asga";

  doCheck = false;

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];

    # golang.org/x/sys needs to be updated due to:
    #
    #   https://github.com/golang/go/issues/49219
    #
    # but this package is no longer maintained.
    #
    broken = stdenv.isDarwin;
  };
};
in
symlinkJoin{
    name = "packr";
    paths = [p1 p2];
}
