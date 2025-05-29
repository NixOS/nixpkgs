{
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  lib,
  numpy,
  pandas,
  pyarrow,
  pytestCheckHook,
  tqdm,
}:

buildPythonPackage rec {
  pname = "embedding-reader";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = "embedding-reader";
    tag = version;
    hash = "sha256-paN6rAyH3L7qCfWPr5kXo9Xl57gRMhdcDnoyLJ7II2w=";
  };

  pythonRelaxDeps = [ "pyarrow" ];

  dependencies = [
    fsspec
    numpy
    pandas
    pyarrow
    tqdm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "embedding_reader" ];

  meta = with lib; {
    description = "Efficiently read embedding in streaming from any filesystem";
    homepage = "https://github.com/rom1504/embedding-reader";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
