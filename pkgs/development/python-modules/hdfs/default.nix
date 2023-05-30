{ lib
, buildPythonPackage
, docopt
, fastavro
, fetchFromGitHub
, nose
, pandas
, pytestCheckHook
, pythonOlder
, requests
, requests-kerberos
, six
}:

buildPythonPackage rec {
  pname = "hdfs";
  version = "2.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mtth";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-r3zt0upD+wzHZh8ktFpztcz3agM5sjz+nb/19ErD3ko=";
  };

  propagatedBuildInputs = [
    docopt
    requests
    six
  ];

  passthru.optional-dependencies = {
    avro = [
      fastavro
    ];
    kerberos = [
      requests-kerberos
    ];
    dataframe = [
      fastavro
      pandas
    ];
  };

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "hdfs"
  ];

  meta = with lib; {
    description = "Python API and command line interface for HDFS";
    homepage = "https://github.com/mtth/hdfs";
    changelog = "https://github.com/mtth/hdfs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
