{ lib, buildOcaml, fetchFromGitHub }:

buildOcaml rec {
  version = "112.35.00";
  pname = "herelib";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "herelib";
    rev = version;
    sha256 = "sha256-EuMhHu2na3lcpsJ1wMVOgBr6VKndlonq8jgAW01eelI=";
  };

  meta = with lib; {
    homepage = "https://github.com/janestreet/herelib";
    description = "Syntax extension for inserting the current location";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
