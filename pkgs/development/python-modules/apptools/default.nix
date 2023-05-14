{ lib
, buildPythonPackage
, configobj
, fetchpatch
, fetchPypi
, importlib-resources
, pandas
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, tables
, traits
, traitsui
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12x5lcs1cllpybz7f0i1lcwvmqsaa5n818wb2165lj049wqxx4yh";
  };

  patches = [
    # python310: Fix tests
    # https://github.com/enthought/apptools/issues/303
    (fetchpatch {
      url = "https://github.com/enthought/apptools/commit/10fb73916124f7ae7edf6c6688a05ad95678488f.patch";
      hash = "sha256-izAcP5RWobLvnk2PQx31SX/TUGkw+prbYbjamYVmtjY=";
      name = "fix_python310_tests.patch";
    })

    # python39: importlib_resources -> importlib.resources. This patch will be included
    # in the next release after 5.1.0.
    (fetchpatch {
      url = "https://github.com/enthought/apptools/commit/0ae4f52f19a8c0ca9d7926e17c7de949097f24b4.patch";
      sha256 = "165aiwjisr5c3lasg7xblcha7y1y5bq23vi3g9gc80c24bzwcbsw";
      name = "fix_importlib-resources_naming.patch";
    })
  ];

  propagatedBuildInputs = [
    configobj
    traits
    traitsui
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    tables
    pandas
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMP
  '';

  pythonImportsCheck = [
    "apptools"
  ];

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications";
    homepage = "https://github.com/enthought/apptools";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
