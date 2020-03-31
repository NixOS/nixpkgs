{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "packr";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m5kl2fq8gf1v4vllgag2xl8fd382sdgqrcdb8f5alsnrdn08kb9";
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
