{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bitarray";
  version = "3.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eVsXYEGKt1CCZCCuJPBvOSwI4h3CNPCjaaacwARE+Ow=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    cd $out
    ${python.interpreter} -c 'import bitarray; bitarray.test()'
  '';

  pythonImportsCheck = [ "bitarray" ];

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = "https://github.com/ilanschnell/bitarray";
    changelog = "https://github.com/ilanschnell/bitarray/raw/${version}/CHANGE_LOG";
    license = licenses.psfl;
  };
}
