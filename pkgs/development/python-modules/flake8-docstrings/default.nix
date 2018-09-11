{ stdenv
, buildPythonPackage
, fetchPypi
, flake8
, pydocstyle
, flake8-polyfill
}:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "flake8-docstrings";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e0ce1476b64e6291520e5570cf12b05016dd4e8ae454b8a8a9a48bc5f84e1cd";
  };

  propagatedBuildInputs = [ flake8 pydocstyle flake8-polyfill ];

  checkPhase = ''
   flake8 flake8_docstrings.py
  '';

  meta = with stdenv.lib; {
    homepage = https://gitlab.com/pycqa/flake8-docstrings;
    description = "Extension for flake8 which uses pydocstyle to check docstrings";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
