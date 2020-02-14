{ 
  lib
  , fetchPypi
  , buildPythonPackage
  , psutil
  , importlib-metadata
}:

buildPythonPackage rec {
  pname = "helpdev";
  version = "0.6.10";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0kmlsx902y4rm0kx432kdka6g7hkddjwl8h2cw4nhl5pb12d4qcy";
  };

  propagatedBuildInputs = [ psutil importlib-metadata ];

  meta = with lib; {
    description = "Extracts information about the Python environment easily";
    homepage = "https://gitlab.com/dpizetta/helpdev";
    license = licenses.mit;
    maintainers = with maintainers; [ marcus7070 ];
  };
}
