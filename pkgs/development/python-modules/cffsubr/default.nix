{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fonttools
, pytestCheckHook
, setuptools-scm
, wheel
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.2.9.post1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "azFBLc9JyPqEZkvahn4u3cVbb+b6aW/yU8TxOp/y/Fw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools-git-ls-files",' ""

    substituteInPlace setup.py \
      --replace '"setuptools-git-ls-files",' ""
  '';

  nativeBuildInputs = [
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    fonttools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cffsubr" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
