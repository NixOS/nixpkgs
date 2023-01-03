{ buildPythonPackage
, fetchFromGitHub
, fsspec
, lib
, numpy
, pandas
, pyarrow
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "embedding-reader";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "rom1504";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-uyeIcAW9O9PR4cqmifC6Lx+Hn6XPb1RH/ksmUWvbdtw=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "pyarrow" ];

  propagatedBuildInputs = [ fsspec numpy pandas pyarrow ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "embedding_reader" ];

  meta = with lib; {
    description = "Efficiently read embedding in streaming from any filesystem";
    homepage = "https://github.com/rom1504/embedding-reader";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
