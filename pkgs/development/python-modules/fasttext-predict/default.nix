{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pybind11,
}:

buildPythonPackage rec {
  pname = "fasttext-predict";
  version = "0.9.2.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "fasttext_predict";
    inherit version;
    hash = "sha256-GKb7DXTH35KA2x+Wy3XZkL/QBPqdZpST6j3T1U+E28c=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace setup.py \
      --replace-fail "-flto" ""
  '';

  nativeBuildInputs = [ pybind11 ];

  # tests are removed from fork
  doCheck = false;

  pythonImportsCheck = [ "fasttext" ];

  meta = with lib; {
    description = "fasttext with wheels and no external dependency, but only the predict method (<1MB)";
    homepage = "https://github.com/searxng/fasttext-predict/";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
