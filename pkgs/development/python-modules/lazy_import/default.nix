{ lib
, buildPythonPackage
, fetchPypi
, pytest-xdist
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "lazy-import";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "lazy_import";
    inherit version;
    hash = "sha256-IUmu+FeUWUB8Ys/szxGFJ5OcmTGs4STzVSNjYGRPij0=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "lazy_import"
  ];

  disabledTests = [
    # Disable obsolete test parts (--boxed was replace by --forked)
    "distutils"
    "sched-errors12-fn1-lazy_callable"
    "sched-errors13-fn1-lazy_callable"
    "sched-errors14-fn1-lazy_callable"
    "sched-errors15-fn1-lazy_callable"
    "sched-errors16-fn1-lazy_callable"
    "sched-errors17-fn1-lazy_callable"
    "sched-errors18-cnames18-lazy_callable"
    "sched-errors19-cnames19-lazy_callable"
    "sched-errors20-cnames20-lazy_callable"
    "sched-errors21-cnames21-lazy_callable"
    "sched-errors22-cnames22-lazy_callable"
    "sched-errors23-cnames23-lazy_callable"
    "sched-None-cnames6-lazy_callable"
    "sched-None-fn1-lazy_callable1"
    "test_callable_missing"
  ];

  meta = with lib; {
    description = "Module that load modules, and related attributes, in a lazy fashion";
    homepage = "https://github.com/mnmelo/lazy_import";
    changelog = "https://github.com/mnmelo/lazy_import/blob/v${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marenz ];
  };
}
