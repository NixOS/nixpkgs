{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace ",<6.0" ""
    substituteInPlace setup.cfg --replace ",<6.0" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with lib; {
    description = "A fast and thorough lazy object proxy";
    homepage = "https://github.com/ionelmc/python-lazy-object-proxy";
    license = with licenses; [ bsd2 ];
  };

}
