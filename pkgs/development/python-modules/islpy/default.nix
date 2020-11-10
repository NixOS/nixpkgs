{ lib
, buildPythonPackage
, fetchPypi
, isl
, pybind11
, pytestCheckHook
, pythonOlder
, cffi
, six
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2020.2.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7eb7dfa41d6a67d9ee4ea4bb9f08bdbcbee42b364502136b7882cfd80ff427e0";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"pytest>=2\"," ""
  '';

  buildInputs = [ isl pybind11 ];
  propagatedBuildInputs = [ six ];

  preCheck = "mv islpy islpy.hidden";
  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "islpy" ];

  meta = with lib; {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
