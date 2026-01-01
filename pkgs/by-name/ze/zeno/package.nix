{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "zeno";
<<<<<<< HEAD
  version = "2.0.19";
=======
  version = "2.0.18";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "internetarchive";
    repo = "Zeno";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-6Or+DREyqljXTUJn5+NrFH2YktOUafHMx5jAL02Tm+4=";
  };

  vendorHash = "sha256-J9ufthZuIULHXkgHj80fDa68fiFJkGSXkhyiPpDYPJU=";
=======
    hash = "sha256-8SSQwJgKGMnGoorDunPmxQNxiBsE1b1R4OJAv85x3MM=";
  };

  vendorHash = "sha256-Zi7wmT72f8KJHkysGg8rWTUk8iMjlYDGeZUFvKmtQtk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  env.CGO_ENABLED = true;
  ldFlags = [
    "-s"
    "-w"
  ];

  # Attempts to access internet
  doCheck = false;

  meta = {
    description = "State-of-the-art web crawler";
    longDescription = ''
      Zeno is a web crawler designed to operate wide crawls or to simply
      archive one web page. Zeno's key concepts are: portability,
      performance, simplicity. With an emphasis on performance.
    '';
    homepage = "https://github.com/internetarchive/Zeno";
    changelog = "https://github.com/internetarchive/Zeno/releases/tag/v${finalAttrs.version}";
    mainProgram = "Zeno";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.RossSmyth ];
  };
})
