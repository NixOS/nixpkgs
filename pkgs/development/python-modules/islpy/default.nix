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
  version = "2023.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NsNI1N9ZuNYWr1i3dl7hSaTP3jdsTYsIpoF98vrZG9Y=";
  };

  postConfigure = ''
    substituteInPlace setup.py \
      --replace "\"pytest>=2\"," ""
  '';

  buildInputs = [ isl pybind11 ];
  propagatedBuildInputs = [ six ];

  preCheck = "mv islpy islpy.hidden";
  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "islpy" ];

  meta = with lib; {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    license = licenses.mit;
    maintainers = [ ];
  };
}
