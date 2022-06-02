{ lib
, buildPythonPackage
, fetchpatch
, fetchFromGitHub
, numpy
, packaging
, pandas
, pyarrow
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "db-dtypes";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-db-dtypes-pandas";
    rev = "v${version}";
    hash = "sha256-7u/E0ICiz7LQfuplm/mkGlWrgGEPqeMwM3CUhfH6868=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/googleapis/python-db-dtypes-pandas/commit/fb30adfd427d3df9919df00b096210ba1eb1b91d.patch";
      sha256 = "sha256-39kZtYGbn3U1WXiDTczki5EM6SjUlSRXz8UMcdTU20g=";
    })
  ];

  propagatedBuildInputs = [
    numpy
    packaging
    pandas
    pyarrow
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "db_dtypes" ];

  meta = with lib; {
    description = "Pandas Data Types for SQL systems (BigQuery, Spanner)";
    homepage = "https://github.com/googleapis/python-db-dtypes-pandas";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
