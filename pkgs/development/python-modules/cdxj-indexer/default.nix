{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  warcio,
  surt,
  py3amf,
  multipart,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cdxj-indexer";
  version = "1.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "cdxj-indexer";
    tag = "v${version}";
    hash = "sha256-E3b/IfjngyXhWvRYP9CkQGvBFeC8pAm4KxZA9MwOo4s=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    warcio
    surt
    py3amf
    multipart
  ];

  pythonRemoveDeps = [
    # Transitive dependency that does not need to be pinned
    # Proposed fix in <https://github.com/webrecorder/cdxj-indexer/pull/25>
    "idna"
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
