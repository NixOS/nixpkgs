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
  version = "0.1.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yPALTn0WG9D6fT6jDInRt0y10/iyNIUuPEo42srLcIY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    orjson
    tqdm
  ];

  # Add proper tests if available
  doCheck = false;

  meta = with lib; {
    description = "Lean client library for Python";
    homepage = "https://pypi.org/project/leanclient/";
    license = licenses.mit;
    maintainers = with maintainers; [ wvhulle ];
  };
}
