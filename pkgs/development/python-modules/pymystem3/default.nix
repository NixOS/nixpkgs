{ lib
, fetchPypi
, buildPythonPackage
, requests
, flake8
, mock
, pytest
, mystem
}:

buildPythonPackage rec {
  pname = "pymystem3";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15gv78m17g958gfka6rr3rg230g6b5ssgk8bfpsp7k2iajhxdbhs";
  };

  propagatedBuildInputs = [ requests ];
  checkInputs = [ flake8 mock pytest ];

  postPatch = ''
    sed -i 's#^_mystem_info = .*#_mystem_info = ["${mystem}/bin", "${mystem}/bin/mystem"]#' pymystem3/constants.py
  '';

  meta = with lib; {
    description = "Python wrapper for the Yandex MyStem 3.1 morpholocial analyzer of the Russian language";
    homepage = "https://github.com/nlpub/pymystem3";
    license = licenses.mit;
    maintainers = with maintainers; [ abbradar ];
  };
}
