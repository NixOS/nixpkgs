{
  lib,
  buildPythonPackage,
  python-dateutil,
  fetchPypi,
  isPy3k,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aniso8601";
  version = "10.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/x0PwjRmiMYsAVFUcTasMOMiiW7YrzFu92AsR9qUJs8=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ] ++ lib.optional (!isPy3k) mock;

  pythonImportsCheck = [ "aniso8601" ];

  meta = with lib; {
    description = "Python Parser for ISO 8601 strings";
    homepage = "https://bitbucket.org/nielsenb/aniso8601";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
