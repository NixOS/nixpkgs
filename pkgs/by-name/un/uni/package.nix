{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "uni";
<<<<<<< HEAD
  version = "2.9.0";
=======
  version = "2.8.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "uni";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-+n+QExNCk5QsavO0Kj/e12v4xFJDnXprJGjyk2i/ioY=";
  };

  vendorHash = "sha256-8nl7iFMmoGuC3pEVi6HqXdwFCKvCDi3DMwRQFjfBC7Y=";
=======
    hash = "sha256-LSmQtndWBc7wCYBnyaeDb4Le4PQPcSO8lTp+CSC2jbc=";
  };

  vendorHash = "sha256-4w5L5Zg0LJX2v4mqLLjAvEdh3Ad69MLa97SR6RY3fT4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = {
    homepage = "https://github.com/arp242/uni";
    description = "Query the Unicode database from the commandline, with good support for emojis";
    changelog = "https://github.com/arp242/uni/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chvp ];
    mainProgram = "uni";
  };
}
