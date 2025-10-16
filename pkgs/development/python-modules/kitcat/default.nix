{
  lib,
  buildPythonPackage,
  setuptools,
  matplotlib,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage rec {
  pname = "kitcat";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mil-ad";
    repo = "kitcat";
    tag = "v${version}";
    hash = "sha256-wAlKXn5v1FI5FreLcCiPUfTmA7WN0E3YFSAtPffOYN4=";
  };

  build-system = [ hatchling ];
  buildInputs = [
    matplotlib
    setuptools
  ];

  meta = {
    description = "Matplotlib backend for direct plotting in the terminal using Kitty graphics protocol";
    homepage = "https://github.com/mil-ad/kitcat";
    changelog = "https://github.com/mil-ad/kitcat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lavafroth ];
  };
}
