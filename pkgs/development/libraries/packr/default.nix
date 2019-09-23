{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "packr";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = pname;
    rev = "v${version}";
    sha256 = "11bd0s3hyzvhcg1q0iahv2w9f0w1k57jfxgswhz7dyndxvvr2b8i";
  };

  subPackages = [ "packr" "v2/packr2" ];

  modSha256 = "0afhkvivma16bi8rz3kwcsz9mhmcn4zm6rrymxkvazx6b844hcdv";

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
