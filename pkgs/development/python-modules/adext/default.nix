{ lib
, buildPythonPackage
, fetchPypi
, alarmdecoder
}:

buildPythonPackage rec {
  pname = "adext";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "184qxw6i5ixnhgkjnby4zwn4jg90mxb8xy9vbg80x5w331p4z50f";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "alarmdecoder==1.13.2" "alarmdecoder>=1.13.2"
  '';

  propagatedBuildInputs = [ alarmdecoder ];

  # Tests are not published yet
  doCheck = false;
  pythonImportsCheck = [ "adext" ];

  meta = with lib; {
    description = "Python extension for AlarmDecoder";
    homepage = "https://github.com/ajschmidt8/adext";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
