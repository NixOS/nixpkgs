{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "packr";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ciffa5xbd93fylwz93wr4m4fj83dcla55dmdshaqz28rbsapnc1";
  };

  modSha256 = "086gydrl3i35hawb5m7rsb4a0llcpdpgid1xfw2z9n6jkwkclw4n";

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
