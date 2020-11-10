{ stdenv
, fetchPypi
, buildPythonPackage
, setuptools_scm
, docutils
, pyparsing
}:

buildPythonPackage rec {
  pname = "amply";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1j2dqdz1y1nbyw33qq89v0f5rkmqfbga72d9hax909vpcapm6pbf";
  };

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    docutils
    pyparsing
  ];

  checkPhase = ''
    python tests/test_amply.py
  '';
  pythonImportsCheck = [ "amply" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/willu47/amply";
    description = ''
      Allows you to load and manipulate AMPL/GLPK data as Python data structures
    '';
    maintainers = with maintainers; [ ris ];
    license = licenses.epl10;
  };
}
