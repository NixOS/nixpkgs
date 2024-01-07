{ aiofiles
, buildPythonPackage
, fetchPypi
, lib
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pure-python-adb";
  version = "0.3.0.dev0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kdr7w2fhgjpcf1k3l6an9im583iqkr6v8hb4q1zw30nh3bqkk0f";
  };

  passthru.optional-dependencies = {
    async = [
      aiofiles
    ];
  };

  doCheck = pythonOlder "3.10"; # all tests result in RuntimeError on 3.10

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async;

  pythonImportsCheck = [
    "ppadb.client"
  ] ++ lib.optionals doCheck [
    "ppadb.client_async"
  ];

  meta = with lib; {
    description = "Pure python implementation of the adb client";
    homepage = "https://github.com/Swind/pure-python-adb";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
