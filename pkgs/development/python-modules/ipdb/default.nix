{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, decorator
, ipython
, isPyPy
, tomli
, setuptools
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "ipdb";
  version = "0.13.11";
  format = "pyproject";

  disabled = isPyPy;  # setupterm: could not find terminfo database

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wjtnNvAf1Fhswuy+vfeaXrRUeWhT4c2PLtO3uR1KPpM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    ipython
    decorator
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    homepage = "https://github.com/gotcha/ipdb";
    description = "IPython-enabled pdb";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
