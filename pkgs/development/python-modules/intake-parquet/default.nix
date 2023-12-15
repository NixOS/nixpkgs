{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, dask
, fastparquet
, pyarrow
}:

buildPythonPackage rec {
  pname = "intake-parquet";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "intake";
    repo = pname;
    rev = version;
    sha256 = "sha256-zSwylXBKOM/tG5mwYtc0FmxwcKJ6j+lw1bxJqf57NY8=";
  };

  propagatedBuildInputs = [
    pandas
    dask
    fastparquet
    pyarrow
  ];

  postPatch = ''
    # Break circular dependency
    substituteInPlace requirements.txt \
      --replace "intake" ""
  '';

  doCheck = false;

  #pythonImportsCheck = [ "intake_parquet" ];

  meta = with lib; {
    description = "Parquet plugin for Intake";
    homepage = "https://github.com/intake/intake-parquet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
