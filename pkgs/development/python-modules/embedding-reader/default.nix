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
  version = "1.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = "embedding-reader";
    tag = version;
    hash = "sha256-D7yrvV6hDqzHaIMhCQ16DhY/8FEr3P4gcT5vV371whs=";
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
