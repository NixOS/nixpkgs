{ lib
, buildPythonPackage
, fetchPypi
, pytestcov
, pytest
, swiProlog
}:

buildPythonPackage rec {
  pname = "pyswip";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4591414006340ad8f033f9f0ee4c4c9151cd5a309ed19741a9c79b9ffce8b58e";
  };

  propagatedNativeBuildInputs = [ swiProlog ];
  checkInputs = [ pytest pytestcov ];
  postFixup = ''
  set -o pipefail -o errexit
  path="$(python -c 'import pyswip.core; print(pyswip.core._path)')"
  home_dir="$(python -c 'import pyswip.core; print(pyswip.core.SWI_HOME_DIR)')"
  find $out -name core.py | xargs -n 1 sed -i "s:(_path, SWI_HOME_DIR) = _findSwipl():(_path, SWI_HOME_DIR) = ('$path', '$home_dir'):"
  '';

  meta = with lib; {
    description = "PySwip enables querying SWI-Prolog in your Python programs";
    homepage = https://github.com/yuce/pyswip;
    license = licenses.mit;
    maintainers = [ maintainers.catern ];
  };
}
