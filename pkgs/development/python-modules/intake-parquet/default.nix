{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  dask,
  fastparquet,
  pyarrow,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "intake-parquet";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "intake";
    repo = "intake-parquet";
    rev = "refs/tags/${version}";
    hash = "sha256-zSwylXBKOM/tG5mwYtc0FmxwcKJ6j+lw1bxJqf57NY8=";
  };

  postPatch = ''
    # Break circular dependency
    substituteInPlace requirements.txt \
      --replace-fail "intake" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pandas
    dask
    fastparquet
    pyarrow
  ];

  doCheck = false;

  #pythonImportsCheck = [ "intake_parquet" ];

  meta = with lib; {
    description = "Parquet plugin for Intake";
    homepage = "https://github.com/intake/intake-parquet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
