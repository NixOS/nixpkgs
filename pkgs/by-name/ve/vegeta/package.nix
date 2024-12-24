{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "vegeta";
  version = "12.12.0";
  rev = "03ca49e9b419c106db29d687827c4c823d8b8ece";

  src = fetchFromGitHub {
    owner = "tsenart";
    repo = "vegeta";
    rev = "v${version}";
    hash = "sha256-nTtQ/BB5rU+0k4dPRCmukCRNI0iFTjHIJiSTN0cNR+Q=";
  };

  vendorHash = "sha256-0Ho1HYckFHaWEE6Ti3fIL/t0hBj5MnKOd4fOZx+LYiE=";

  subPackages = [ "." ];

  ldflags =
    (lib.mapAttrsToList (n: v: "-X main.${n}=${v}") {
      Version = version;
      Commit = rev;
      Date = "1970-01-01T00:00:00Z";
    })
    ++ [
      "-s"
      "-w"
      "-extldflags '-static'"
    ];

  meta = with lib; {
    description = "Versatile HTTP load testing tool";
    longDescription = ''
      Vegeta is a versatile HTTP load testing tool built out of a need to drill
      HTTP services with a constant request rate. It can be used both as a
      command line utility and a library.
    '';
    homepage = "https://github.com/tsenart/vegeta/";
    changelog = "https://github.com/tsenart/vegeta/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
    mainProgram = "vegeta";
  };
}
