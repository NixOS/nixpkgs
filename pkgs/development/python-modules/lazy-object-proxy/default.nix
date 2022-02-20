{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d609c75b986def706743cdebe5e47553f4a5a1da9c5ff66d76013ef396b5a8a4";
  };

  nativeBuildInputs = [
    setuptools-scm
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
