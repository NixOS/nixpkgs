{ lib
, buildPythonPackage
, fetchPypi
, isl
, pybind11
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2021.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3f49de925149dbf2482e648016507cd66d0dce6668a1bc4de5e7a937e9c576d";
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
