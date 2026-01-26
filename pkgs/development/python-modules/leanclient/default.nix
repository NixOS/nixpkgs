{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  orjson,
  tqdm,
}:

buildPythonPackage rec {
  pname = "leanclient";
  version = "0.1.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cSow9A4AnKnv3y0HUkeM28FYRsgCBTRKVpWDpCH1juc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    orjson
    tqdm
  ];

  doCheck = true;

  meta = {
    description = "Lean client library for Python";
    homepage = "https://pypi.org/project/leanclient/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wvhulle ];
  };
}
