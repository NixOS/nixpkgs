{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, html5lib
, pythonOlder
, rdflib
, setuptools
}:

buildPythonPackage rec {
  pname = "pyrdfa3";
  version = "3.5.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "pyRdfa3";
    hash = "sha256-FXZjqSuH3zRbb2m94jXf9feXiRYI4S/h5PqNrWhxMa4=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/RDFLib/pyrdfa3/pull/40
      name = "CVE-2022-4396.patch";
      url = "https://github.com/RDFLib/pyrdfa3/commit/ffd1d62dd50d5f4190013b39cedcdfbd81f3ce3e.patch";
      hash = "sha256-prRrOwylYcEqKLr/8LIpyJ5Yyt+6+HTUqH5sQXU8tqc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'html = pyRdfa.rdflibparsers:StructuredDataParser'" "'html = pyRdfa.rdflibparsers:StructuredDataParser'," \
      --replace "'hturtle = pyRdfa.rdflibparsers:HTurtleParser'" "'hturtle = pyRdfa.rdflibparsers:HTurtleParser',"
    # https://github.com/RDFLib/pyrdfa3/issues/31
    substituteInPlace pyRdfa/utils.py \
      --replace "imp," ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    rdflib
    html5lib
  ];

  pythonImportsCheck = [
    "pyRdfa"
  ];

  meta = with lib; {
    description = "RDFa 1.1 distiller/parser library";
    homepage = "https://github.com/prrvchr/pyrdfa3/";
    changelog = "https://github.com/prrvchr/pyrdfa3/releases/tag/v${version}";
    license = licenses.w3c;
    maintainers = with maintainers; [ ambroisie ];
  };
}
