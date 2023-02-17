{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, isPy27
, rdflib
, html5lib
}:

buildPythonPackage rec {
  pname = "pyrdfa3";
  version = "3.5.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit version;
    pname = "pyRdfa3";
    sha256 = "sha256-FXZjqSuH3zRbb2m94jXf9feXiRYI4S/h5PqNrWhxMa4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-4396.patch";
      url = "https://github.com/RDFLib/pyrdfa3/commit/ffd1d62dd50d5f4190013b39cedcdfbd81f3ce3e.patch";
      hash = "sha256-prRrOwylYcEqKLr/8LIpyJ5Yyt+6+HTUqH5sQXU8tqc=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'html = pyRdfa.rdflibparsers:StructuredDataParser'" "'html = pyRdfa.rdflibparsers:StructuredDataParser'," \
      --replace "'hturtle = pyRdfa.rdflibparsers:HTurtleParser'" "'hturtle = pyRdfa.rdflibparsers:HTurtleParser',"
  '';

  propagatedBuildInputs = [
    rdflib
    html5lib
  ];

  # Does not work with python3
  doCheck = false;

  pythonImportsCheck = [ "pyRdfa" ];

  meta = with lib; {
    description = "RDFa 1.1 distiller/parser library";
    homepage = "https://www.w3.org/2012/pyRdfa/";
    license = licenses.w3c;
    maintainers = with maintainers; [ ambroisie ];
  };
}
