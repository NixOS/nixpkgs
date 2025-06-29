{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  warcio,
  surt,
  py3amf,
  multipart,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cdxj-indexer";
  version = "1.4.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "cdxj-indexer";
    tag = "v${version}";
    hash = "sha256-E3b/IfjngyXhWvRYP9CkQGvBFeC8pAm4KxZA9MwOo4s=";
  };

  # This upstream performs the questionable practice of pinning transitive
  # dependencies to resolve conflicts.
  dependencies = [
    warcio
    surt
    py3amf
    multipart
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cdxj_indexer"
  ];

  meta = {
    description = "CDXJ Indexing of WARC/ARCs";
    homepage = "https://github.com/webrecorder/cdxj-indexer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zhaofengli ];
    mainProgram = "cdxj-indexer";
  };
}
