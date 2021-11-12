{ lib
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
    sha256 = "5f22e7bcb969006738e1aa4219c75a32f34c2d62d46dc9d2fb2d3e0b0287e4b7";
  };

  patches = [
    (fetchpatch {
      # test_Class_params fails in 0.10.0
      # https://github.com/pdoc3/pdoc/issues/355
      url = "https://github.com/pdoc3/pdoc/commit/4aa70de2221a34a3003a7e5f52a9b91965f0e359.patch";
      sha256 = "07sbf7bh09vgd5z1lbay604rz7rhg88414whs6iy60wwbvkz5c2v";
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
