{
  lib,
  buildPythonPackage,
  matplotlib,
  fetchFromGitHub,
  uv-build,
}:

buildPythonPackage rec {
  pname = "kitcat";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mil-ad";
    repo = "kitcat";
    tag = "v${version}";
    hash = "sha256-r3AIsHQKGVrRzxXszupp8ZjgbjGHv4QJ75IEhgiOUm4=";
  };

  buildInputs = [ matplotlib ];
  build-system = [ uv-build ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.13,<0.12.0" "uv_build"
  '';

  meta = {
    description = "Matplotlib backend for direct plotting in the terminal using Kitty graphics protocol";
    homepage = "https://github.com/mil-ad/kitcat";
    changelog = "https://github.com/mil-ad/kitcat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lavafroth ];
  };
}
