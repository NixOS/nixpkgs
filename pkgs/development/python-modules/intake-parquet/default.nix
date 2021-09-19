{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pandas
, dask
, fastparquet
, pyarrow
}:

buildPythonPackage rec {
  pname = "intake-parquet";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "intake";
    repo = pname;
    rev = version;
    sha256 = "037jd3qkk6dybssp570kzvaln2c6pk2avd2b5mll42gaxdxxnp02";
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
