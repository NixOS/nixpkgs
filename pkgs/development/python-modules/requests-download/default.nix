{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-download";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "requests_download";
    tag = finalAttrs.version;
    hash = "sha256-KLbROCvXNhvnoZHX5aGrXUI38oQuCM88ctIM/02Nmsc=";
  };

  build-system = [ flit ];
  dependencies = [ requests ];

  meta = {
    description = "Download files using requests and save them to a target path";
    homepage = "https://github.com/takluyver/requests_download";
    license = lib.licenses.mit;
  };
})
