{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, Mako
, markdown
, setuptools-git
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pdoc3";
  version = "0.10.0";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XyLnvLlpAGc44apCGcdaMvNMLWLUbcnS+y0+CwKH5Lc=";
  };

  patches = [
    (fetchpatch {
      # test_Class_params fails in 0.10.0
      # https://github.com/pdoc3/pdoc/issues/355
      url = "https://github.com/pdoc3/pdoc/commit/4aa70de2221a34a3003a7e5f52a9b91965f0e359.patch";
      hash = "sha256-W7Dy516cA+Oj0ZCTQBB6MJ+fCTBeLRp+aW8nANdxSx8=";
    })
    # https://github.com/pdoc3/pdoc/issues/400
    (fetchpatch {
      name = "fix-test-for-python310.patch";
      url = "https://github.com/pdoc3/pdoc/commit/80af5d40d3ca39e2701c44941c1003ae6a280799.patch";
      hash = "sha256-69Cn+BY7feisSHugONIF/PRgEDEfnvnS/RBHWv1P8/w=";
      excludes = [".github/workflows/ci.yml"];
    })
  ];

  nativeBuildInputs = [
    setuptools-git
    setuptools-scm
  ];

  propagatedBuildInputs = [
    Mako
    markdown
  ];

  meta = with lib; {
    description = "Auto-generate API documentation for Python projects.";
    homepage = "https://pdoc3.github.io/pdoc/";
    license = with licenses; [ agpl3Plus ];
    maintainers = with maintainers; [ catern ];
  };
}
