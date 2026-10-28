{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "mailmanclient";
  version = "3.3.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y1gcYEyn6sAhSJwVqsygaklY63b2ZXTG+rBerGVN2Fc=";
  };

  propagatedBuildInputs = [ requests ];

  # Tests require a running Mailman instance
  doCheck = false;

  pythonImportsCheck = [ "mailmanclient" ];

  meta = {
    description = "REST client for driving Mailman 3";
    homepage = "https://www.gnu.org/software/mailman/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.linux;
  };
}
