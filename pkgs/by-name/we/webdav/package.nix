{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "webdav";
<<<<<<< HEAD
  version = "5.10.1";
=======
  version = "5.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hacdias";
    repo = "webdav";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-V4PNDtKyB0uoMY4ehWQUeTa1ZqIYAvL3Xm2rWw9zKTE=";
  };

  vendorHash = "sha256-nrvL+glI4kVFUELege8q7z62AsvrLMw5JxigZkZ8kkY=";
=======
    hash = "sha256-A8Gt3HWspV01AZC4mxj4i9+CnrMX0XcIvW5X4nnKvig=";
  };

  vendorHash = "sha256-jBCtTBqHXY7786G+QOlU0BB3g+qmsGGOg96xSGv6hXI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple WebDAV server";
    homepage = "https://github.com/hacdias/webdav";
    changelog = "https://github.com/hacdias/webdav/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pmy
      pbsds
    ];
    mainProgram = "webdav";
  };
}
