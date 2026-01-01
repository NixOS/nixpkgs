{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "versitygw";
<<<<<<< HEAD
  version = "1.0.20";
=======
  version = "1.0.19";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uRYGcV1vXZS7tCuj4riBU4ROQQkYbTFSYYNJa0Dy1mA=";
  };

  vendorHash = "sha256-tZUSxfy9wAFausFrEGRrgXZj8PHp6XeF10jPdD4zyDk=";
=======
    hash = "sha256-Cz8hxw+10Cg112Qu+9/FTDWVaf2COBzVJDxZkt8c4Yg=";
  };

  vendorHash = "sha256-R2UxUaqPaQ1TPYI79rmIHVqTDceuqhSdRb03OqI2fBc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  doCheck = false; # Require access to online S3 services

  ldFlags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "versitygw";
  };
}
