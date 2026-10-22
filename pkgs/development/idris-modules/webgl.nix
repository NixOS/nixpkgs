{
  build-idris-package,
  fetchFromGitHub,
  idrisscript,
  lib,
}:
build-idris-package {
  pname = "webgl";
  version = "2017-05-08";

  idrisDeps = [ idrisscript ];

  src = fetchFromGitHub {
    owner = "pierrebeaucamp";
    repo = "idris-webgl";
    rev = "1b4ee00a06b0bccfe33eea0fa8f068cdae690e9e";
    hash = "sha256-pg0re/hJqWz8aMq2uRCzOhYL7hYeLZ+HBW2Mi+QV9CQ=";
  };

  meta = {
    description = "Idris library to interact with WebGL";
    homepage = "https://github.com/pierrebeaucamp/idris-webgl";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
