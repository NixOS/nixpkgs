{
  buildPythonPackage,
  fetchFromGitHub,
  fsspec,
  lib,
  numpy,
  pandas,
  pyarrow,
  pytestCheckHook,
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "embedding-reader";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-paN6rAyH3L7qCfWPr5kXo9Xl57gRMhdcDnoyLJ7II2w=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pyarrow" ];

  propagatedBuildInputs = [
    fsspec
    numpy
    pandas
    pyarrow
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
