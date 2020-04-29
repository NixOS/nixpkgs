{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
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

  modSha256 = "1xxqyn78074jna0iri7sks6b2l4sdnn5sg57n09vrrf6kh39h2y9";

  meta = with stdenv.lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
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

  modSha256 = "045qfdi82yhpghjd0cimxhas4nkj7g30n9qyvkrl9ck01sahx76f";

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
};
in
symlinkJoin{
    name = "packr";
    paths = [p1 p2];
}
