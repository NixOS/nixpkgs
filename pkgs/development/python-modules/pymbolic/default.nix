{ lib
, buildPythonPackage
, fetchPypi
, matchpy
, pytestCheckHook
, pythonOlder
, pytools
}:

buildPythonPackage rec {
  pname = "pymbolic";
  version = "2022.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tS9FHdC5gD4D3jMgrzt85XIwcAYcbSMcACFvbaQlkBI=";
  };

  propagatedBuildInputs = [
    pytools
  ];

  checkInputs = [
    matchpy
    pytestCheckHook
  ];

  postPatch = ''
    # pytest is a test requirement not a run-time one
      substituteInPlace setup.py \
        --replace '"pytest>=2.3",' ""
  '';

  pythonImportsCheck = [
    "pymbolic"
  ];

  meta = with lib; {
    description = "A package for symbolic computation";
    homepage = "https://documen.tician.de/pymbolic/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
