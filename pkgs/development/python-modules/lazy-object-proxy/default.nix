{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-whmgAkWvD2+k6VkB7SgERUT1AVKEDFtqPnslaNs00VY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace ",<6.0" ""
    substituteInPlace setup.cfg --replace ",<6.0" ""
  '';

  nativeCheckInputs = [
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
