{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "allpairspy";
  version = "2.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9p0xo7Vu7hGdHsYGPpxzLdRPu6NS73OMsi2WmfxACf4=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    setuptools
  ];

  pythonImportsCheck = [
    "allpairspy"
  ];

  meta = with lib; {
    description = "Pairwise test combinations generator";
    homepage = "https://github.com/thombashi/allpairspy";
    changelog = "https://github.com/thombashi/allpairspy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
