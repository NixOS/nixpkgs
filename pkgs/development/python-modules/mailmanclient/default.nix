{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y1gcYEyn6sAhSJwVqsygaklY63b2ZXTG+rBerGVN2Fc=";
  };

  propagatedBuildInputs = [ requests ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # Tests require a running Mailman instance
  doCheck = false;

  pythonImportsCheck = [ "mailmanclient" ];

  meta = with lib; {
    description = "REST client for driving Mailman 3";
    homepage = "https://www.gnu.org/software/mailman/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
