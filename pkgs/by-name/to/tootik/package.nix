{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  openssl,
}:

buildGoModule rec {
  pname = "tootik";
<<<<<<< HEAD
  version = "0.20.2";
=======
  version = "0.20.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dimkr";
    repo = "tootik";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zkKkHzgIBHg0FH07KNr7jGNZU4QUbl6udoD7hLaDOL0=";
=======
    hash = "sha256-WCv7cJUoD3+ZJQ9c63rtkEohtDkU5LgmwBwBcHmbVxw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-UZQw63KPs7GzOv5Ls69DLqJqc/taWwC5UCYdNlq9fXc=";

  nativeBuildInputs = [ openssl ];

  preBuild = ''
    go generate ./migrations
  '';

  ldflags = [ "-X github.com/dimkr/tootik/buildinfo.Version=${version}" ];

  tags = [ "fts5" ];

  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64);

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Federated nanoblogging service with a Gemini frontend";
    homepage = "https://github.com/dimkr/tootik";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sikmir ];
    mainProgram = "tootik";
  };
}
