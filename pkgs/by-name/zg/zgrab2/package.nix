{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "zgrab2";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zmap";
    repo = "zgrab2";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-rvQum+Mjpuz2XRgTY94CTqJ6Tvi78Kdd3CCMHvYZQgE=";
  };

  vendorHash = "sha256-ag2VWBNv2u/DXWWsSLBfRscm3++AjxgrGfw8JUlhnRo=";
=======
    hash = "sha256-9YDrWtSFFzFMN/pp0Kaknie4NMduOb/ZNrP+7MIMT+0=";
  };

  vendorHash = "sha256-8oidWUtSMMm/QMzrTkH07eyyBhCeZ9SUOO1+h1evbac=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [
    "cmd/zgrab2"
  ];

  meta = {
    description = "Fast Application Layer Scanner";
<<<<<<< HEAD
    homepage = "https://github.com/zmap/zgrab2";
    changelog = "https://github.com/zmap/zgrab2/releases/tag/vv${finalAttrs.version}";
=======
    mainProgram = "zgrab2";
    homepage = "https://github.com/zmap/zgrab2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = with lib.licenses; [
      asl20
      isc
    ];
    maintainers = with lib.maintainers; [
      fab
      juliusrickert
    ];
<<<<<<< HEAD
    mainProgram = "zgrab2";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
