{ lib, fetchPypi, buildPythonPackage
, fetchpatch, configobj, six, traitsui
, pytestCheckHook, tables, pandas
, pythonOlder, importlib-resources
}:

buildPythonPackage rec {
  pname = "apptools";
  version = "5.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12x5lcs1cllpybz7f0i1lcwvmqsaa5n818wb2165lj049wqxx4yh";
  };

  patches = [
    # python39: importlib_resources -> importlib.resources. This patch will be included
    # in the next release after 5.1.0.
    (fetchpatch {
      url = "https://github.com/enthought/apptools/commit/0ae4f52f19a8c0ca9d7926e17c7de949097f24b4.patch";
      sha256 = "165aiwjisr5c3lasg7xblcha7y1y5bq23vi3g9gc80c24bzwcbsw";
    })
  ];

  propagatedBuildInputs = [
    configobj
    six
    traitsui
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    tables
    pandas
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMP
  '';

  meta = with lib; {
    description = "Set of packages that Enthought has found useful in creating a number of applications.";
    homepage = "https://github.com/enthought/apptools";
    maintainers = with maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
